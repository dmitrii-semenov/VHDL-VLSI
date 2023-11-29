----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2023 15:33:51
-- Design Name: 
-- Module Name: dig_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dig_top is
    Port ( CLK  : in  STD_LOGIC;
           rst  : in  STD_LOGIC;
           CS_b : in  STD_LOGIC;
           SCLK : in  STD_LOGIC;
           MOSI : in  STD_LOGIC;
           MISO : out  STD_LOGIC);
end dig_top;

architecture Behavioral of dig_top is

component spi
    Port ( CLK                      : in  STD_LOGIC;
           rst                      : in  STD_LOGIC;	        
	       CS_b                     : in  STD_LOGIC;
           SCLK                     : in  STD_LOGIC;
           MOSI                     : in  STD_LOGIC;
           MISO                     : out STD_LOGIC;
           fr_start                 : out STD_LOGIC;
           fr_end                   : out STD_LOGIC;
           fr_err                   : out STD_LOGIC;
           data_out                 : out STD_LOGIC_VECTOR(15 downto 0);
           data_in                  : in  STD_LOGIC_VECTOR(15 downto 0);
           load_data                : in  STD_LOGIC);  
  end component;
  
component pkt_ctrl
    Port ( fr_start                 : in  STD_LOGIC;
           fr_end                   : in  STD_LOGIC;
           fr_err                   : in  STD_LOGIC;
		   CLK                      : in  STD_LOGIC;
		   rst                      : in  STD_LOGIC;
           data_out                 : in  STD_LOGIC_VECTOR (15 downto 0);
           add_res                  : in  STD_LOGIC_VECTOR (15 downto 0);
           mul_res                  : in  STD_LOGIC_VECTOR (15 downto 0);
           we_data_fr1              : out  STD_LOGIC;
           we_data_fr2              : out  STD_LOGIC;
           data_fr1                 : out  STD_LOGIC_VECTOR (15 downto 0);
           data_fr2                 : out  STD_LOGIC_VECTOR (15 downto 0);
           wr_data                  : out  STD_LOGIC;
           data_in                  : out  STD_LOGIC_VECTOR (15 downto 0));
  end component;
  
component arith_unit
    Port ( CLK                      : in STD_LOGIC;
		   rst                      : in STD_LOGIC;
		   we_data_fr1              : in  STD_LOGIC;
		   we_data_fr2              : in  STD_LOGIC;
		   data_fr1                 : in  STD_LOGIC_VECTOR (15 downto 0);
		   data_fr2                 : in  STD_LOGIC_VECTOR (15 downto 0);
		   add_res                  : out  STD_LOGIC_VECTOR (15 downto 0);
		   mul_res                  : out  STD_LOGIC_VECTOR (15 downto 0));
  end component;
  
component detector_RE
    Port ( CLK                      : in STD_LOGIC;
		   rst                      : in STD_LOGIC;
		   det_in                   : in  STD_LOGIC;
		   det_out                  : out  STD_LOGIC);
  end component;

signal fr_start, fr_end, fr_err : STD_LOGIC;
signal data_out, data_in        : STD_LOGIC_VECTOR(15 downto 0);
signal data_fr1, data_fr2       : STD_LOGIC_VECTOR(15 downto 0);
signal load_data, load_data_s   : STD_LOGIC;
signal add_res, mul_res         : STD_LOGIC_VECTOR(15 downto 0);
signal we_data_fr1, we_data_fr2 : STD_LOGIC;
    
begin

    unit1: spi
    port map(
	   CLK         => CLK,
	   rst         => rst,
	   CS_b        => CS_b,
	   SCLK        => SCLK,
	   MOSI        => MOSI,
       MISO        => MISO,
	   fr_start    => fr_start,
	   fr_end      => fr_end,
	   fr_err      => fr_err,
	   data_out    => data_out,
	   data_in     => data_in,
	   load_data   => load_data_s);
	   
	unit2: pkt_ctrl
    port map(
	   fr_start    => fr_start,
       fr_end      => fr_end,
       fr_err      => fr_err,
	   CLK         => CLK,
	   rst         => rst,
       data_out    => data_out,
       add_res     => add_res,
       mul_res     => mul_res,
       we_data_fr1 => we_data_fr1,
       we_data_fr2 => we_data_fr2,
       data_fr1    => data_fr1,
       data_fr2    => data_fr2,
       wr_data     => load_data,
       data_in     => data_in);
       
    unit3: arith_unit
    port map(
	   CLK         => CLK,
	   rst         => rst,
       add_res     => add_res,
       mul_res     => mul_res,
       we_data_fr1 => we_data_fr1,
       we_data_fr2 => we_data_fr2,
       data_fr1    => data_fr1,
       data_fr2    => data_fr2);
       
    unit4: detector_RE
    port map(
	   CLK         => CLK,
	   rst         => rst,
       det_in      => load_data,
       det_out     => load_data_s);
  
end Behavioral;
