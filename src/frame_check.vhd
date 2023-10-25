----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:52:01 10/18/2023 
-- Design Name: 
-- Module Name:    frame_check - Behavioral 
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

entity frame_check is
	 generic (
			fr_LENGTH : natural := 16);
    Port ( clk : in  STD_LOGIC;
			  sclk_re : in  STD_LOGIC;
			  cs_b_re : in  STD_LOGIC;
			  cs_b_fe : in  STD_LOGIC;
           fr_en_b : in  STD_LOGIC;
			  fr_start : out  STD_LOGIC;
			  fr_end : out  STD_LOGIC;
           fr_err : out  STD_LOGIC);
end frame_check;

architecture Behavioral of frame_check is

signal sig_c : integer := 0;
signal sig_s : integer := 0;

signal sig_out : STD_LOGIC := '0';

begin
--	p_sek : process (clk) begin
--		if rising_edge(clk) then
--			if sclk_re = '1' then
--				if fr_en_b = '0' then
--					sig_n <= sig_n + 1;
--				else
--					if sig_n = fr_LENGTH then
--						sig_out <= '0';
--					elsif sig_n = 0 then
--						sig_out <= '0';
--					else
--						sig_out <= '1';
--					end if;
--				sig_n <= 0;
--				end if;
--			end if;
--		end if;
--end process;

	p_sek : process (clk) begin
		if rising_edge(clk) then
			if sclk_re = '1' then
				sig_s <= sig_c;
			end if;
		end if;
	end process;
	
	p_komb : process(fr_en_b,sig_s) begin
			if fr_en_b = '0' then
				sig_c <= sig_s + 1;
			else
				sig_c <= 0;
			end if;
			
			if sig_s > 1 then
				sig_out <= '1';
			else
				sig_out <= '0';
			end if;
	end process;

fr_start <= cs_b_fe;
fr_end <= cs_b_re;
fr_err <= sig_out;

end Behavioral;

