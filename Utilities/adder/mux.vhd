LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity mux is
	port(sel,in1,in2 : in std_logic;
		out1 : out std_logic);
end entity mux;

architecture beh of mux is
begin
	out1 <= in1 when sel = '0'
	else in2;
end beh;
		
