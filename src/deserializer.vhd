----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:19:49 10/04/2023 
-- Design Name: 
-- Module Name:    serializer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity deserializer is
	generic (
			g_WIDTH : natural := 4);
   Port ( data : out  STD_LOGIC_VECTOR ((g_WIDTH - 1) downto 0);
           shift_en : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           stream : in  STD_LOGIC);
end deserializer;

architecture Behavioral of deserializer is

signal sig_D : STD_LOGIC_VECTOR ((g_WIDTH - 1) downto 0);
signal sig_Q : STD_LOGIC_VECTOR ((g_WIDTH - 1) downto 0);

begin

p_sek : process (clk) begin -- D flip-flop operation process
	if rising_edge(clk) then
		if rst = '1' then -- reset output of all D FF if rst == 1
			sig_Q <= (others => '0');
		else
			sig_Q <= sig_D; -- D FF normal function mode(input transfer to the output with every tising edge of 'clk')
		end if;
	end if;
end process;

p_comb : process (shift_en, stream, sig_D, sig_Q) begin	-- Combination logic process
	if shift_en = '1' then	-- Mode with shifting input data to the variable "sig_D"(later assigned to the output "data")
		sig_D(g_WIDTH-1) <= stream;
		for idx in 0 to (g_WIDTH - 2) loop -- shifting all bits in vector sig_D to one position to the MSB
			sig_D(g_WIDTH-2-idx) <= sig_Q(g_WIDTH-1-idx);
		end loop;
	else
		sig_D <= sig_Q; -- Mode with '0' enable signal, output vector value is unchanged, mode of "keeping" value on the output
	end if;
end process;

data <= sig_Q; -- assigning sig_Q value to the output vector "data"

end Behavioral;
