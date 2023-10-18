--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:18:41 09/27/2023
-- Design Name:   
-- Module Name:   V:/detector/tb_detector_RE.vhd
-- Project Name:  detector
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: detector_RE
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
 
ENTITY tb_detector_RE IS
END tb_detector_RE;
 
ARCHITECTURE behavior OF tb_detector_RE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT detector_RE
    PORT(
         clk : IN  std_logic;
         sig_in : IN  std_logic;
         sig_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal sig_in : std_logic := '0';

 	--Outputs
   signal sig_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 5 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: detector_RE PORT MAP (
          clk => clk,
          sig_in => sig_in,
          sig_out => sig_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;
	
	p_stimulus : process
   begin
		sig_in <= '0';
		wait for 10 ns;
		sig_in <= '1';
		wait for 30 ns;
		sig_in <= '0';
		wait for 20 ns;
		sig_in <= '1';
		wait for 100 ns;
		sig_in <= '0';
		wait for 20 ns;
		sig_in <= '1';
		wait for 10 ns;
	end process;

END;
