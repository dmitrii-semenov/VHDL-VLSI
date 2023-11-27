----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.11.2023 19:23:47
-- Design Name: 
-- Module Name: TB - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB is
--  Port ( );
end TB;

architecture Behavioral of TB is

COMPONENT dig_top
    PORT(
         CLK   : IN  std_logic;
         rst   : IN  std_logic;
         CS_b  : IN  std_logic;
         SCLK  : IN  std_logic;
         MOSI  : IN  std_logic;
         MISO  : OUT  std_logic
        );
    END COMPONENT;
    
--Inputs
signal CLK  : std_logic := '0';
signal rst  : std_logic := '0';
signal CS_b : std_logic := '1';
signal SCLK : std_logic := '1';
signal MOSI : std_logic := '0';

--Outputs
signal MISO : std_logic;

--custom signals
signal frame_end, frame_start : STD_LOGIC := '0';
signal mosi_data : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
signal mosi_cnt, miso_cnt  : integer := 0;
signal miso_data : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
signal sum_result : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal mul_result : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

-- Clock period definitions
constant clk_period : time := 20 ns; -- 50 MHz CLK
signal sclk_period : time := 1 us;   -- 1 MHz SCLK
	
signal frame_width : integer := 16; -- default frame width

procedure tc_spi_001 (signal clk : STD_LOGIC;
                      signal miso_data : in STD_LOGIC_VECTOR(17 downto 0);
	                  signal rst : out STD_LOGIC;
					  signal cs_b  : out STD_LOGIC;
					  signal mosi_data : out STD_LOGIC_VECTOR(17 downto 0);
					  signal sum_result, mul_result : inout STD_LOGIC_VECTOR(15 downto 0);
					  signal frame_width : out integer
                      ) is begin
    
    -- Reset DUT
    rst <= '0';
    wait for clk_period*5;
    rst <= '1';		
    wait for clk_period*5;
    rst <= '0';
	wait for clk_period*5;
	
	-- send first number 000001110.000101101 (14.087890625) - shall be ignored
	frame_width <= 18;
	mosi_data  <= "000001110000101101";	
    cs_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*5;
	cs_b       <= '1';
	wait for   sclk_period*5;
	
	-- send second number 00001010.01110100 (10.453125)
	frame_width <= 16;
	mosi_data  <= "000000101001110100";	
    cs_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*5;
	cs_b       <= '1';
	wait for   sclk_period*5;
	
	-- send third number 001110.000101 (14.078125)  - shall be ignored
	frame_width <= 12;
	mosi_data  <= "000000001110000101";	
    cs_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*5;
	cs_b       <= '1';
	wait for   sclk_period*5;
	
	-- send forth number 00000101.10011111 (5.62109375)
	frame_width <= 16;
	mosi_data  <= "000000010110011111";	
    cs_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*5;
	cs_b       <= '1';
	wait for   sclk_period*5;
	
	-- send two numbers to receive the results, value is not important
	frame_width <= 16;
	mosi_data  <= "000000000000000000";	
    cs_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*5;
	cs_b       <= '1';
	wait for   sclk_period*5;
	-- save addition result
	sum_result <= miso_data(15 downto 0);
	
	frame_width <= 16;
	mosi_data  <= "000000000000000000";		
    cs_b       <= '0';
	wait until frame_end = '1';
	wait for   sclk_period*5;
	cs_b       <= '1';
	wait for   sclk_period*5;
	-- save multiplication result
	mul_result <= miso_data(15 downto 0);
	
	-- result check
	if(sum_result /= "0001000000010011") then
	   write(OUTPUT, "tc_spi_001: relult of sum is NOT correct" & LF);
	end if; 
	if(mul_result /= "0011101011000010") then
	   write(OUTPUT, "tc_spi_001: relult of mul is NOT correct" & LF);
	end if;

end procedure;

begin

-- Instantiate the Unit Under Test (UUT)
uut: dig_top PORT MAP (
       CLK  => CLK,
       rst  => rst,
       CS_b => CS_b,
       SCLK => SCLK,
       MOSI => MOSI,
       MISO => MISO
     );

-- CLK generation
clk_process :process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;
 
-- SCLK generation
sclk_process :process
begin
    wait until cs_b = '0';
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
	   wait for sclk_period*5;
	   frame_end <= '0';
    end if;    
end process;

-- data send process
mosi_process :process
begin
    wait on sclk;
	if(falling_edge(sclk)) then
        mosi     <= mosi_data(mosi_cnt);
		mosi_cnt <= mosi_cnt + 1;
    end if;
	if(mosi_cnt = frame_width) then
	    mosi_cnt   <= 0;
	end if;
end process;
  
-- data receive process
miso_process :process
begin
    wait on sclk;
	if(rising_edge(sclk)) then
	   wait for 2 ns;
       miso_data(miso_cnt) <= miso;
	   miso_cnt <= miso_cnt + 1;
    end if;
	if(miso_cnt = 16) then
	   miso_cnt   <= 0;
	end if;
end process;

-- main testcase
testcase :process
begin
    sclk_period <= 1 us; -- 1 MHz SCLK frequency
    tc_spi_001(clk, miso_data, rst, cs_b, mosi_data, sum_result, mul_result, frame_width);
end process;

end Behavioral;
