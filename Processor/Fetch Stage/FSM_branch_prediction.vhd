Library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_textio.all;


Entity FSM is
	port(input,clk,rst,we:in  std_logic; --to start from given state
		inputState : in integer range 0 to 3;
		outputState : out integer range 0 to 3;
		output : out std_logic);
end FSM;

architecture moore of FSM is
type ram_type is array (0 to (2**8)) of std_logic_vector(15 Downto 0);
-- signal read_address : std_logic_vector(11 downto 0);
signal counter : std_logic_vector(1 downto 0) := "00";
signal PredictionBuffer : ram_type;

type state_type is (st,wt,snt,wnt);
signal state : state_type := snt;
begin
state_process: process(clk,rst,we,inputState)
begin
if we='1' then 	state <= state_type'VAL(inputState) ; 
end if;
if rst = '1' then state <= wt;
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
when snt | wnt => output<= '0';
when st | wt => output <= '1';
end case;
outputState<=state_type'POS(state) ; 
end process;  
end moore;
		

