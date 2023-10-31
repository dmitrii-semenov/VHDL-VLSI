----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:28:33 10/25/2023 
-- Design Name: 
-- Module Name:    spi - Behavioral 
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

entity spi is
    Port ( CLK : in  STD_LOGIC;
           CS_b : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           SCLK : in  STD_LOGIC;
           MOSI : in  STD_LOGIC;
           MISO : out  STD_LOGIC;
           fr_start : out  STD_LOGIC;
           fr_end : out  STD_LOGIC;
           fr_err : out  STD_LOGIC;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0);
           data_in : in  STD_LOGIC_VECTOR (7 downto 0);
           data_load : in  STD_LOGIC);
end spi;

architecture Behavioral of spi is

signal cs_b_re : STD_LOGIC;
signal cs_b_fe : STD_LOGIC;
signal cs_b_o : STD_LOGIC;
signal sclk_re : STD_LOGIC;
signal sclk_fe : STD_LOGIC;
signal sclk_o : STD_LOGIC;

begin

	cs_b_dff : entity work.ddf
		port map (
			clk => clk,
			rst => rst,
			input => CS_b,
			output => cs_b_o
		);
		
	sclk_dff : entity work.ddf
		port map (
			clk => clk,
			rst => rst,
			input => SCLK,
			output => sclk_o
		);
		
	cs_R : entity work.detector_RE
		port map (
			clk => clk,
			rst => rst,
			det_in => cs_b_o,
			det_out => cs_b_re
		);
		
	cs_F : entity work.detector_FE
		port map (
			clk => clk,
			rst => rst,
			det_in => cs_b_o,
			det_out => cs_b_fe
		);
		
	sclk_R : entity work.detector_RE
		port map (
			clk => clk,
			rst => rst,
			det_in => sclk_o,
			det_out => sclk_re
		);
		
	sclk_F : entity work.detector_FE
		port map (
			clk => clk,
			rst => rst,
			det_in => sclk_o,
			det_out => sclk_fe
		);
		
	frame_det : entity work.frame_check
		port map (
			clk => clk,
			rst => rst,
			sclk_re => sclk_re,
			cs_b_re => cs_b_re,
			cs_b_fe => cs_b_fe,
            fr_en_b => cs_b_o,
			fr_start => fr_start,
			fr_end => fr_end,
            fr_err => fr_err
		);

end Behavioral;

