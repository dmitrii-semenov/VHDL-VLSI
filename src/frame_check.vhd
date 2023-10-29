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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
			  rst_b : in  STD_LOGIC;
			  cs_b_re : in  STD_LOGIC;
			  cs_b_fe : in  STD_LOGIC;
              fr_en_b : in  STD_LOGIC;
			  fr_start : out  STD_LOGIC;
			  fr_end : out  STD_LOGIC;
              fr_err : out  STD_LOGIC);
end frame_check;

architecture Behavioral of frame_check is

signal sig_c : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

begin
	p_sek: process(clk, rst_b) begin
    if(rst_b = '0') then
	   sig_c <= (others => '0');
    elsif(rising_edge(clk)) then
      if(fr_en_b = '0' and sclk_re = '1' and fr_err = '0') then
		  sig_c <= sig_c + 1;
		elsif(fr_en_b = '1') then
        sig_c <= (others => '0');		
		end if;
    end if;	 
  end process;
	
p_comb: process(fr_en_b, sig_c) begin
   if((sig_c /= 0) and (fr_en_b = '1') and (sig_c < 16) ) then
     fr_err <= '1';
	elsif(sig_c > 16) then
	  fr_err <= '1';
	else
	  fr_err <= '0';
   end if;
  end process;

out_flags: process(rst_b, cs_b_fe, cs_b_re) begin
      fr_start <= cs_b_re and rst_b;
      fr_end   <= cs_b_fe and rst_b;
  end process;

end Behavioral;

