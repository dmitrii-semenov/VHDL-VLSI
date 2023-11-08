--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:32:17 10/04/2023
-- Design Name:   
-- Module Name:   V:/detector/tb_frame_check.vhd
-- Project Name:  detector
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: frame_check
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
 
ENTITY tb_frame_check IS
END tb_frame_check;
 
ARCHITECTURE behavior OF tb_frame_check IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	 constant c_length : natural := 16;
    

   --Inputs
   signal fr_en : std_logic := '0';
   signal clk : std_logic := '0';
	signal sclk_re : std_logic := '0';

 	--Outputs
    signal fr_err : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 1 ns;
	constant sclk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.frame_check 
		generic map (
			 fr_LENGTH => c_length
			 )
		PORT MAP (
          fr_en => fr_en,
          clk => clk,
			 sclk_re => sclk_re,
          fr_err => fr_err
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	sclk_process :process
   begin
		sclk_re <= '1';
		wait for clk_period/2;
		sclk_re <= '0';
		wait for (sclk_period - clk_period/2);
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
		fr_en <= '0';
		wait for 100 ns;
		
		fr_en <= '1';
		wait for 160 ns;
		
		fr_en <= '0';
		wait for 120 ns;
		
		fr_en <= '1';
		wait for 180 ns;
		
		fr_en <= '0';
		wait for 120 ns;
		
		fr_en <= '1';
		wait for 130 ns;
		
		fr_en <= '0';
		wait for 120 ns;
		
      wait;
   end process;

END;
