----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:27:52 11/08/2023 
-- Design Name: 
-- Module Name:    pkt_ctrl - Behavioral 
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

entity pkt_ctrl is
    Port ( fr_start : in  STD_LOGIC;
           fr_end : in  STD_LOGIC;
           fr_err : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
           data_out : in  STD_LOGIC_VECTOR (15 downto 0);
           add_res : in  STD_LOGIC_VECTOR (15 downto 0);
           mul_res : in  STD_LOGIC_VECTOR (15 downto 0);
           we_data_fr1 : out  STD_LOGIC;
           we_data_fr2 : out  STD_LOGIC;
           data_fr1 : out  STD_LOGIC_VECTOR (15 downto 0);
           data_fr2 : out  STD_LOGIC_VECTOR (15 downto 0);
           wr_data : out  STD_LOGIC;
           data_in : out  STD_LOGIC_VECTOR (15 downto 0));
end pkt_ctrl;

architecture Behavioral of pkt_ctrl is

type state_type is (s0,s1,s2,s3,s4);
-- s0: state after reset or frame error 
-- s1: receive first frame
-- s2: wait for second frame
-- s3: receive second frame
-- s4: wait for first frame 
signal next_state : state_type;
signal present_state : state_type;
signal frame_num : STD_LOGIC; -- '0' first frame, '1' - second
signal time_flag : STD_LOGIC; -- send time error(REQ_ AAU_I_023)

begin

-- FF process
process(clk,rst) 
begin
	if rst = '1' then
		present_state <= s0;
	elsif rising_edge(clk) then
		present_state <= next_state;
	end if;
end process;

-- FSM states definition, combinational part
process(fr_start,fr_end,fr_err,present_state,time_flag)
begin
	case present_state is
	
		when s0 =>
			if fr_start = '1' then
				next_state <= s1;
				frame_num <= '0';
			else
				next_state <= s0;
			end if;
			
		when s1 =>
			if fr_err = '1' then
				next_state <= s0;
			elsif fr_end = '1' then
				next_state <= s2;
			else 
				next_state <= s1;
			end if;
		
		when s2 =>
			if time_flag = '1' then
				next_state <= s0;
			elsif fr_start = '1' then
				next_state <= s3;
				frame_num <= '1';
			else
				next_state <= s2;
			end if;
		
		when s3 =>
			if fr_err = '1' then
				next_state <= s0;
			elsif fr_end = '1' then
				next_state <= s4;
			else 
				next_state <= s3;
			end if;
		
		when s4 =>
			if fr_start = '1' then
				next_state <= s1;
				frame_num <= '0';
			else
				next_state <= s4;
			end if;
		
	end case;
end process;

-- Enable frame 1 data write 
process(present_state)
begin
	if (present_state = s2) and (frame_num = '0') then
		we_data_fr1 <= '1';
	else 
		we_data_fr1 <= '0';
	end if;
end process;

-- Enable frame 2 data write 
process(present_state)
begin
	if (present_state = s4) and (frame_num = '1') then
		we_data_fr2 <= '1';
	else 
		we_data_fr2 <= '0';
	end if;
end process;

end Behavioral;
