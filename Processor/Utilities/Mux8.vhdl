library IEEE;
use IEEE.std_logic_1164.all;
entity Mux8 is
generic (N : Integer := 32);
port(
  a1      : in  std_logic_vector(N-1 downto 0);
  a2      : in  std_logic_vector(N-1 downto 0);
  a3      : in  std_logic_vector(N-1 downto 0);
  a4      : in  std_logic_vector(N-1 downto 0);
  a5      : in  std_logic_vector(N-1 downto 0);
  sel     : in  std_logic_vector(2 downto 0);
  b       : out std_logic_vector(N-1 downto 0));
end Mux8;

architecture arch_mux8 of mux8 is
begin
  b <= a1 when (sel = "000") else
       a2 when (sel = "001") else
       a3 when (sel = "010") else
       a4 when (sel = "011") else
       a5 when (sel = "100") else
       (others => 'Z');
end arch_mux8;
