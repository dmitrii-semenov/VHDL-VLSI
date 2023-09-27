----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:10:09 09/27/2023 
-- Design Name: 
-- Module Name:    detector_signal - Behavioral 
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

entity detector_signal is
    Port ( clk : in  STD_LOGIC;
           sig_in : in  STD_LOGIC;
           sig_out : out  STD_LOGIC);
end detector_signal;

architecture Behavioral of detector_signal is

signal sig_Q : std_logic;
signal sig_xor : std_logic;

begin

p_dff : process (clk) begin
	if rising_edge(clk) then
		sig_Q <= sig_in;
	end if;
end process;

p_cnr : process (sig_in, sig_Q) begin
	sig_xor <= sig_in xor sig_Q;
	sig_out <=  sig_in and sig_xor;
end process;

end Behavioral;

