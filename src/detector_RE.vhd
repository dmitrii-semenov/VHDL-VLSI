----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:10:09 09/27/2023 
-- Design Name: 
-- Module Name:    detector_RE - Behavioral 
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

entity detector_RE is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           det_in : in  STD_LOGIC;
           det_out : out  STD_LOGIC);
end detector_RE;

architecture Behavioral of detector_RE is

signal sig_Q : std_logic;

begin

p_dff : process (clk) begin
    if (rst = '1') then
        sig_Q <= '0';
	elsif rising_edge(clk) then
		sig_Q <= det_in;
	end if;
end process;

p_cnr : process (det_in, sig_Q) begin
	det_out <=  det_in and (det_in xor sig_Q);
end process;

end Behavioral;
