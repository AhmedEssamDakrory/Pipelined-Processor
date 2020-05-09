LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity adder is
	generic(n : integer := 16);
	port(A,B : in std_logic_vector(n-1 downto 0);
		cin : in std_logic;
		S : out std_logic_vector(n-1 downto 0);
		cout : out std_logic);
end entity;

architecture str1 of adder is

component blockk is
	port(a,b,aa,bb,cin:in std_logic;
		cout,sout1,sout2:out std_logic);
end component;

component fadder is
	port(cin,a,b : in std_logic;
		cout,s : out std_logic);
end component;

component mux is
	port(sel,in1,in2 : in std_logic;
		out1 : out std_logic);
end component;

signal s0 , s1 : std_logic_vector(n-1 downto 0);
signal c0,c1,c : std_logic_vector(n/2-1 downto 0);
begin

u: for i in 0 to ((n/2)-1) generate
	u0 : blockk port map(A(i*2) , B(i*2) , A(i*2+1) , B(i*2+1) , '0' , c0(i) , s0(i*2) , s0(i*2+1));
	u1 : blockk port map(A(i*2) , B(i*2) , A(i*2+1) , B(i*2+1) , '1' , c1(i) , s1(i*2) , s1(i*2+1));
	i1 : if i = 0 generate
		u2 : mux port map(cin , s0(i*2) , s1(i*2) , s(i*2));
		u6 : mux port map(cin , s0(i*2+1) , s1(i*2+1) , s(i*2+1));
		u4 : mux port map(cin , c0(i) , c1(i) , c(i) );
	end generate;
	i2: if i > 0 generate
		u3 : mux port map(c(i-1), s0(i*2) , s1(i*2) , s(i*2));
		u7 : mux port map(c(i-1), s0(i*2+1) , s1(i*2+1) , s(i*2+1));
		u5 : mux port map(c(i-1) , c0(i) , c1(i), c(i));
	end generate;	
end generate;

cout <= c(3);
	
end str1;

