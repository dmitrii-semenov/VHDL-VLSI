----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:26:15 11/21/2023 
-- Design Name: 
-- Module Name:    arith_unit - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity arith_unit is
    Port ( 	clk : in STD_LOGIC;
				rst : in STD_LOGIC;
				we_data_fr1 : in  STD_LOGIC;
				we_data_fr2 : in  STD_LOGIC;
				data_fr1 : in  STD_LOGIC_VECTOR (15 downto 0);
				data_fr2 : in  STD_LOGIC_VECTOR (15 downto 0);
				add_res : out  STD_LOGIC_VECTOR (15 downto 0);
				mul_res : out  STD_LOGIC_VECTOR (15 downto 0));
end arith_unit;

architecture Behavioral of arith_unit is

	signal resized_fr1 : signed (16 downto 0);
	signal data_fr1_s : signed (15 downto 0);
	signal data_fr2_s : signed (15 downto 0);
	signal add_res_s : STD_LOGIC_VECTOR (15 downto 0);
	signal add_res_c : signed (16 downto 0);
	signal mul_res_c : signed (31 downto 0);
	signal mul_res_s : STD_LOGIC_VECTOR (15 downto 0);
	signal result_en : STD_LOGIC;
	signal mul_sign : STD_LOGIC;

begin
	
p_seq: process (clk, rst) begin -- receive data
	if rst = '1' then
		-- reset
		add_res <= (others => '0');
		mul_res <= (others => '0');
	elsif rising_edge(clk) then
		--input latches
		if we_data_fr1 = '1' then
			data_fr1_s <= signed(data_fr1);
		end if;
		if we_data_fr2 = '1' then
			data_fr2_s <= signed(data_fr2);
		end if;
		
		--output latches
		if result_en = '1' then
			add_res <= add_res_s;
			mul_res <= mul_res_s;
		end if;
	end if;
end process;

p_write: process (clk, rst) begin -- enable data send
    if rst = '1' then
        result_en <= '0';
    elsif rising_edge(clk) then
        result_en <= we_data_fr2;
    end if;
end process;

p_add: process (data_fr1_s, data_fr2_s) begin -- "+" operation
    resized_fr1 <= resize(data_fr1_s, 17);
	add_res_c <= resized_fr1 + data_fr2_s;
end process;

p_add_round: process(add_res_c) begin -- round and overflow of "+" operation
    if (add_res_c(16 downto 15) = "01") then
        add_res_s <= "0111111111111111"; -- round if result is higher than max
    elsif (add_res_c(16 downto 15) = "10") then
        add_res_s <= "1000000000000000"; -- round if result is lower than max
    else
        add_res_s <= STD_LOGIC_VECTOR(add_res_c(15 downto 0));
    end if;
end process;

p_mul: process (data_fr1_s, data_fr2_s) begin -- "*" operation
    mul_sign <= data_fr1_s(15) xor data_fr2_s(15);
	mul_res_c <= data_fr1_s * data_fr2_s;
end process;

p_mul_round: process(add_res_c) begin -- round and overflow of "*" operation
    if (mul_res_c(31 downto 24) = "00000000") and (mul_res_c(23) = mul_sign) then
        mul_res_s <= STD_LOGIC_VECTOR(mul_res_c(23 downto 8));
    elsif (mul_sign = '0') then
        mul_res_s <= "0111111111111111"; -- round if result is higher than max
    else
        mul_res_s <= "1000000000000000"; -- round if result is lower than max
    end if;
end process;

end Behavioral;

