----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2023 11:09:25
-- Design Name: 
-- Module Name: TB_SPI_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_SPI_top is
end TB_SPI_top;

architecture Behavioral of TB_SPI_top is

COMPONENT spi
    PORT(
         CLK : IN  std_logic;
         CS_b : IN  std_logic;
         rst : IN  std_logic;
         SCLK : IN  std_logic;
         MOSI : IN  std_logic;
         MISO : OUT  std_logic;
		   fr_end : OUT  STD_LOGIC;
         fr_start : OUT  std_logic;
         fr_err : OUT  std_logic;
         data_out : OUT  std_logic_vector(15 downto 0);
         data_in : IN  std_logic_vector(15 downto 0);
         load_data : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal CS_b : std_logic := '1';
   signal rst : std_logic := '0';
   signal SCLK : std_logic := '1';
   signal MOSI : std_logic := '0';
   signal data_in : std_logic_vector(15 downto 0) := (others => '0');
   signal load_data : std_logic := '0';

 	--Outputs
   signal MISO : std_logic;
   signal fr_start : std_logic;
   signal fr_end : std_logic;
   signal fr_err : std_logic;
   signal data_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 1 ns;
   signal SCLK_period : time := 10 ns;
   
   -- Custom signals for TB
   signal frame_width : integer := 16;
   signal frame_end, frame_start : STD_LOGIC := '0';
   signal mosi_cnt, miso_cnt  : integer := 0;
   signal miso_data : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
   signal mosi_data : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
   
   -- Task send frame
   procedure task_send_frame(signal clk : in STD_LOGIC;
                             signal miso_data : in STD_LOGIC_VECTOR(15 downto 0);
                             signal rst : out STD_LOGIC;
                             signal CS_b : out STD_LOGIC;
                             signal mosi_data : out STD_LOGIC_VECTOR(15 downto 0)
                             ) is begin  
    -- send first number:
    mosi_data  <= "1100100100100001";	
    CS_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*3;
	CS_b       <= '1';
	wait for   sclk_period*4;
	
	-- send second number
	mosi_data  <= "1110100100001111"; 	
    CS_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*3;
	CS_b       <= '1';
	wait for   sclk_period*4;
	
	-- send third number: 0
	mosi_data  <= "0000000000000000"; --0		
    CS_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*3;
	CS_b       <= '1';
	wait for   sclk_period*4;
	 
   end procedure;
	 
begin

uut: spi PORT MAP (
          CLK => CLK,
          CS_b => CS_b,
          rst => rst,
          SCLK => SCLK,
          MOSI => MOSI,
          MISO => MISO,
          fr_start => fr_start,
          fr_end => fr_end,
          fr_err => fr_err,
          data_out => data_out,
          data_in => data_in,
          load_data => load_data
        );
-- CLK generation
CLK_process :process
begin
    CLK <= '0';
	wait for CLK_period/2;
	CLK <= '1';
	wait for CLK_period/2;
end process;

-- SCLK generation
sclk_process :process
  begin
    wait until CS_b = '0';
    if(frame_end = '0') then
	   wait for sclk_period*2;
		frame_start <= '1';
	   for i in 0 to (frame_width-1) loop
		  sclk <= '0';
		  wait for sclk_period/2;
		  sclk <= '1';
		  wait for sclk_period/2;
		end loop;
		frame_start <= '0';
		frame_end <= '1';
		wait for sclk_period;
		frame_end <= '0';
    end if;    
  end process;
  
mosi_process :process
  begin
    wait on sclk;
	 if(falling_edge(sclk)) then
      mosi <= mosi_data(mosi_cnt);
		mosi_cnt <= mosi_cnt + 1;
    end if;
	 if(mosi_cnt = frame_width) then
	   mosi_cnt <= 0;
	 end if;
  end process;
  
miso_process :process
  begin
    wait on sclk;
	 if(rising_edge(sclk)) then
	   wait for 2 ns;
      miso_data(miso_cnt) <= miso;
		miso_cnt <= miso_cnt + 1;
    end if;
	 if(miso_cnt = frame_width) then
	   miso_cnt <= 0;
	 end if;
  end process;
  
 testcase :process
 begin
 
     -- RST
     wait for 100 ns;
     rst <= '1';
     wait for 100 ns;
     rst <= '0';
	  wait for 10 ns;
	  
     SCLK_period <= 10 ns;
     frame_width <= 16;
     task_send_frame(clk,miso_data,rst,CS_b,mosi_data);
     wait;
     
 end process;
   
data_in <= data_out;
load_data <= fr_end;
  
end Behavioral;
