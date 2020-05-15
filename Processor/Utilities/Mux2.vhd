library IEEE;
use IEEE.std_logic_1164.all;
entity Mux2 is
generic (N : Integer := 32);
port(
  a1      : in  std_logic_vector(N-1 downto 0);
  a2      : in  std_logic_vector(N-1 downto 0);
  sel     : in  std_logic;
  b       : out std_logic_vector(N-1 downto 0));
end Mux2;

architecture arch_mux2 of mux2 is
begin
  b <= a1 when (sel = '0') else
       a2;
end arch_mux2;

