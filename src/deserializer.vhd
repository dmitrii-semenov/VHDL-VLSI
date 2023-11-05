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
   Port ( data : out  STD_LOGIC_VECTOR (15 downto 0);
           shift_en_b : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           cs_b_re : in STD_LOGIC;
           sclk_re : in  STD_LOGIC;
           stream : in  STD_LOGIC);
end deserializer;

architecture Behavioral of deserializer is

signal reg : STD_LOGIC_VECTOR (15 downto 0);

begin

process (clk) begin 
		if rst = '1' then
			reg <= (others => '0');
		elsif rising_edge(clk) then
		  if (shift_en_b = '0' and sclk_re = '1')  then
		      reg(15) <= stream;
		      reg(14 downto 0) <= reg(15 downto 1);
		  end if;
		end if;
end process;

process (clk, rst, reg, cs_b_re) begin
    if rst = '1' then
        data <= (others => '0');
    elsif rising_edge(clk) then
        if cs_b_re = '1' then
            data <= reg;
        end if; 
    end if;
end process;


end Behavioral;
