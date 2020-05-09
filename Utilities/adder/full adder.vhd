LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity fadder is
	port(cin,a,b : in std_logic;
		cout,s : out std_logic);
end entity;

architecture flw of fadder is
signal temp : std_logic;
begin
	temp <= a xor b;
	s <= temp xor cin;
	cout <= (a and b) or (cin and temp);
end flw;
	
