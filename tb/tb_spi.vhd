--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:43:21 10/25/2023
-- Design Name:   
-- Module Name:   V:/detector/tb_spi.vhd
-- Project Name:  detector
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spi
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_spi IS
END tb_spi;
 
ARCHITECTURE behavior OF tb_spi IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi
    PORT(
         CLK : IN  std_logic;
         CS_b : IN  std_logic;
         SCLK : IN  std_logic;
         MOSI : IN  std_logic;
         MISO : OUT  std_logic;
			fr_end : OUT  STD_LOGIC;
         fr_start : OUT  std_logic;
         fr_err : OUT  std_logic;
         data_out : OUT  std_logic_vector(7 downto 0);
         data_in : IN  std_logic_vector(7 downto 0);
         data_load : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal CS_b : std_logic := '0';
   signal SCLK : std_logic := '0';
   signal MOSI : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal data_load : std_logic := '0';

 	--Outputs
   signal MISO : std_logic;
   signal fr_start : std_logic;
   signal fr_end : std_logic;
   signal fr_err : std_logic;
   signal data_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 1 ns;
   constant SCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi PORT MAP (
          CLK => CLK,
          CS_b => CS_b,
          SCLK => SCLK,
          MOSI => MOSI,
          MISO => MISO,
          fr_start => fr_start,
          fr_end => fr_end,
          fr_err => fr_err,
          data_out => data_out,
          data_in => data_in,
          data_load => data_load
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   SCLK_process :process
   begin
		SCLK <= '0';
		wait for SCLK_period/2;
		SCLK <= '1';
		wait for SCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
		CS_b <= '1';
		wait for 20 ns;
		
		CS_b <= '0';
		wait for 160 ns;
		
		CS_b <= '1';
		wait for 50 ns;
		
		CS_b <= '0';
		wait for 200 ns;
		
		CS_b <= '1';
		wait for 50 ns;
		
		CS_b <= '0';
		wait for 160 ns;
		
		CS_b <= '1';
		wait for 50 ns;
		
		CS_b <= '0';
		wait for 120 ns;
		
		CS_b <= '1';
		wait for 50 ns;
		
      wait;
   end process;

END;
