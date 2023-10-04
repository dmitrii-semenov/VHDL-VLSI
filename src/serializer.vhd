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

entity serializer is
	generic (
			g_WIDTH : natural := 4);
   Port ( data : in  STD_LOGIC_VECTOR ((g_WIDTH - 1) downto 0);
           load_en : in  STD_LOGIC;
           shift_en : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           stream : out  STD_LOGIC);
end serializer;

architecture Behavioral of serializer is

signal sig_D : STD_LOGIC_VECTOR ((g_WIDTH - 1) downto 0);
signal sig_Q : STD_LOGIC_VECTOR ((g_WIDTH - 1) downto 0);

begin

p_sek : process (clk) begin
	if rising_edge(clk) then
		if rst = '1' then
			sig_Q <= (others => '0');
		else
			sig_Q <= sig_D;
		end if;
	end if;
end process;

p_comb : process (load_en,shift_en, data, sig_D, sig_Q) begin
	if load_en = '1' then
		sig_D <= data;
	elsif shift_en = '1' then
		sig_D(0) <= '0';
		for idx in 0 to (g_WIDTH - 2) loop
			sig_D(idx+1) <= sig_Q(idx);
		end loop;
	else
		sig_D <= sig_Q;
	end if;
end process;

stream <= sig_Q(g_WIDTH - 1);

end Behavioral;

