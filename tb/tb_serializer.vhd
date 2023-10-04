--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:36:51 10/04/2023
-- Design Name:   
-- Module Name:   V:/detector/tb_serializer.vhd
-- Project Name:  detector
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: serializer
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
 
ENTITY tb_serializer IS
END tb_serializer;
 
ARCHITECTURE behavior OF tb_serializer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	 constant c_length : natural := 16;
 
--    COMPONENT serializer
--    PORT(
--         data : IN  std_logic_vector((c_length - 1) downto 0);
--         load_en : IN  std_logic;
--         shift_en : IN  std_logic;
--         rst : IN  std_logic;
--         clk : IN  std_logic;
--         stream : OUT  std_logic
--        );
--    END COMPONENT;
    
   --Inputs
   signal data : std_logic_vector((c_length - 1) downto 0) := (others => '0');
   signal load_en : std_logic := '0';
   signal shift_en : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal stream : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.serializer 
		generic map (
			g_WIDTH => c_length
			)
		PORT MAP (
          data => data,
          load_en => load_en,
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
      rst <= '1';
      wait for 100 ns;	
		rst <= '0';
      wait for clk_period*10;

      data <= "1011011001011101";
		load_en <= '1';
		shift_en <= '0';
		wait for clk_period;
		shift_en <= '1';
		load_en <= '0';
		wait for 400 ns;
		
		data <= "0110101111011010";
		load_en <= '1';
		shift_en <= '0';
		wait for 2*clk_period;
		load_en <= '0';
		wait for 5*clk_period;
		shift_en <= '1';
	
      wait;
   end process;

END;
