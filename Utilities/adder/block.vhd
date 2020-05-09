LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity blockk is
	port(a,b,aa,bb,cin:in std_logic;
		cout,sout1,sout2:out std_logic);
end entity;

architecture str of blockk is
component fadder is
	port(cin,a,b : in std_logic;
		cout,s : out std_logic);
end component;
signal c1 : std_logic;
begin
	u0: fadder port map(cin , a , b , c1 , sout1 );
	u1: fadder port map(c1 , aa , bb , cout , sout2);
end str;
