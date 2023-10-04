--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:32:17 10/04/2023
-- Design Name:   
-- Module Name:   V:/detector/tb_deserializer.vhd
-- Project Name:  detector
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: deserializer
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
 
ENTITY tb_deserializer IS
END tb_deserializer;
 
ARCHITECTURE behavior OF tb_deserializer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	 constant c_length : natural := 16;
    

   --Inputs
   signal shift_en : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal stream : std_logic := '0';

 	--Outputs
   signal data : std_logic_vector((c_length - 1) downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.deserializer 
		generic map (
			 g_WIDTH => c_length
			 )
		PORT MAP (
          data => data,
          shift_en => shift_en,
          rst => rst,
          clk => clk,
          stream => stream
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
      rst <= '1';
      wait for 100 ns;	
		rst <= '0';
      wait for clk_period*10;	
		
		shift_en <= '0';
		stream <= '1';
		wait for 2*clk_period;
		
		shift_en <= '1';
		stream <= '0';
		wait for 2*clk_period;
		stream <= '1';
		wait for 2*clk_period;
		stream <= '0';
		wait for 2*clk_period;
		stream <= '1';
		wait for 2*clk_period;
		stream <= '1';
		wait for 2*clk_period;
		stream <= '0';
		shift_en <= '0';
		wait for 2*clk_period;
		stream <= '1';
		wait for 2*clk_period;
		stream <= '0';
		wait for 2*clk_period;
		rst <= '1';
		wait for 2*clk_period;
		rst <= '0';
      -- insert stimulus here 

		shift_en <= '0';
		stream <= '1';
		wait for 2*clk_period;
		
		shift_en <= '1';
		stream <= '0';
		wait for 2*clk_period;
		stream <= '1';
		wait for 2*clk_period;
		stream <= '0';
		wait for 2*clk_period;
		stream <= '1';
		wait for 2*clk_period;
		stream <= '1';
		wait for 2*clk_period;
		stream <= '0';
		wait for 2*clk_period;
		stream <= '1';
		wait for 2*clk_period;
		stream <= '0';
		wait for 2*clk_period;
		rst <= '1';
		wait for 2*clk_period;
      wait;
   end process;

END;
