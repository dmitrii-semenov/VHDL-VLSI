--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:39:12 11/25/2023
-- Design Name:   
-- Module Name:   /mnt/c/Users/vikto/OneDrive - VUT/5.semestr/NDI/Ubuntu/arith_unit/tb_arith_unit.vhd
-- Project Name:  arith_unit
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: arith_unit
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
 
ENTITY tb_arith_unit IS
END tb_arith_unit;
 
ARCHITECTURE behavior OF tb_arith_unit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT arith_unit
    PORT(
         clk : IN  std_logic;
		 rst : IN std_logic;
         we_data_fr1 : IN  std_logic;
         we_data_fr2 : IN  std_logic;
         data_fr1 : IN  std_logic_vector(15 downto 0);
         data_fr2 : IN  std_logic_vector(15 downto 0);
         add_res : OUT  std_logic_vector(15 downto 0);
         mul_res : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst: std_logic := '0';
   signal we_data_fr1 : std_logic := '0';
   signal we_data_fr2 : std_logic := '0';
   signal data_fr1 : std_logic_vector(15 downto 0) := (others => '0');
   signal data_fr2 : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal add_res : std_logic_vector(15 downto 0);
   signal mul_res : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: arith_unit PORT MAP (
          clk => clk,
		  rst => rst,
          we_data_fr1 => we_data_fr1,
          we_data_fr2 => we_data_fr2,
          data_fr1 => data_fr1,
          data_fr2 => data_fr2,
          add_res => add_res,
          mul_res => mul_res
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
      wait for 30 ns;	
      rst <= '0';

      -- insert stimulus here 
		we_data_fr1 <= '0';
		we_data_fr2 <= '0';
		wait for 20 ns;
		
		data_fr1 <= "0000101001110100";
		data_fr2 <= "0000010110011111";
		
		wait for 10 ns;		
		we_data_fr1 <= '1';
		wait for 10 ns;		
		we_data_fr1 <= '0';
		wait for 10 ns;	
		we_data_fr2 <= '1';
		wait for 10 ns;		
		we_data_fr2 <= '0';
		wait for 50 ns;	
		
		data_fr1 <= "0000011110100111";
		data_fr2 <= "0000100110011001";
		
		wait for 10 ns;		
		we_data_fr1 <= '1';
		wait for 10 ns;		
		we_data_fr1 <= '0';
		wait for 10 ns;	
		we_data_fr2 <= '1';
		wait for 10 ns;		
		we_data_fr2 <= '0';
		wait for 50 ns;	

		data_fr1 <= "0000010100100000";
		data_fr2 <= "0000101111000000";
		
		wait for 10 ns;		
		we_data_fr1 <= '1';
		wait for 10 ns;		
		we_data_fr1 <= '0';
		wait for 10 ns;	
		we_data_fr2 <= '1';
		wait for 10 ns;		
		we_data_fr2 <= '0';
		wait for 50 ns;		
		
      wait;
   end process;

END;
