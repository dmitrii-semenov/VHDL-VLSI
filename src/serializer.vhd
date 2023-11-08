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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity serializer is
	generic (
		g_WIDTH : natural := 16);
   Port ( 
		data : in  STD_LOGIC_VECTOR (g_WIDTH-1 downto 0);
		load_en : in  STD_LOGIC;
		shift_en : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		clk : in  STD_LOGIC;
		stream : out  STD_LOGIC;
		stream_en : in  STD_LOGIC);
end serializer;

architecture Behavioral of serializer is

signal sig_Q_in : STD_LOGIC := '0';
signal sig_reg_out : STD_LOGIC_VECTOR ((g_WIDTH - 1) downto 0) := (others => '0');
signal sig_reg_in : STD_LOGIC_VECTOR ((g_WIDTH - 1) downto 0) := (others => '0');
signal sig_Q_out : STD_LOGIC :='0';
signal sig_x_in : natural range 0 to 15 := 0;
signal sig_x_out : natural range 0 to 15 := 0;
begin

p_seq: process (clk) begin 
	if rising_edge(clk) then
		if rst = '1' then
			--0
		else
			sig_reg_out <= sig_reg_in;
			sig_Q_out <= sig_Q_in;
		end if;
	end if;
end process;



p_comb: process (shift_en, load_en, sig_Q_out, sig_Q_in, sig_x_out, sig_reg_out, stream_en) begin
	if load_en = '1' then --load data
		sig_reg_in <= data;
		sig_Q_in <= '0';
	elsif stream_en = '1' then
		sig_Q_in <= '0';
	elsif shift_en = '1' then
		sig_reg_in <= '0' & sig_reg_out(15 downto 1);
		sig_Q_in <= sig_reg_out(0);
	else
		sig_reg_in <= sig_reg_out;
		sig_Q_in <= sig_Q_out;
	end if;
end process;

stream <= sig_Q_out;

end Behavioral;