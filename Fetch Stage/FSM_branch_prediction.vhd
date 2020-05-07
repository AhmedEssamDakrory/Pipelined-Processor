Library ieee;
use ieee.std_logic_1164.all;

Entity FSM is
	port(input,clk,rst:in  std_logic;
		output : out std_logic);
end FSM;

architecture moore of FSM is
type state_type is (st,wt,snt,wnt);
signal state : state_type := snt;
begin

state_process: process(clk,rst)
begin
if rst = '1' then state <= snt;
elsif rising_edge(clk) then
case state is
when snt => if input = '1' then state <= wnt; end if;
when wnt => if input = '0' then state <= snt; else state <= wt; end if;
when wt => if input = '0' then state <= wnt; else state <= st; end if;
when st => if input = '0' then state <= wt; else state <= st; end if;
end case;
end if;
end process;

out_process: process(state)
begin
case state is
when snt | wnt => output <= '0';
when st | wt => output <= '1';
end case;
end process;  

end moore;
		

