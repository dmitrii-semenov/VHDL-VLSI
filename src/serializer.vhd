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
   Port ( data : in  STD_LOGIC_VECTOR (15 downto 0);
           load_en : in  STD_LOGIC;
           shift_en_b : in  STD_LOGIC;
           sclk_re : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           stream : out  STD_LOGIC);
end serializer;

architecture Behavioral of serializer is

signal reg : STD_LOGIC_VECTOR (15 downto 0);

begin

process (clk) begin 
		if rst = '1' then
			reg <= (others => '0');
			stream <= '0';
		elsif rising_edge(clk) then
		  if (shift_en_b = '0' and sclk_re = '1' and load_en = '0')  then
		      reg(14 downto 0) <= reg(15 downto 1);
		      reg(15) <= '0';
		  end if;
		end if;
end process;

process (reg, load_en, shift_en_b) begin
    if load_en = '1' then
        reg <= data;
    elsif shift_en_b = '0' then
        stream <= reg(0);
    else
        stream <= '0';
    end if;
end process;

end Behavioral;
