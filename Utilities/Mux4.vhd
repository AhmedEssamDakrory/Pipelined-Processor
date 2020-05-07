library IEEE;
use IEEE.std_logic_1164.all;
entity Mux4 is
generic (N : Integer := 32);
port(
  a1      : in  std_logic_vector(N-1 downto 0);
  a2      : in  std_logic_vector(N-1 downto 0);
  a3      : in  std_logic_vector(N-1 downto 0);
  a4      : in  std_logic_vector(N-1 downto 0);
  sel     : in  std_logic_vector(1 downto 0);
  b       : out std_logic_vector(N-1 downto 0));
end Mux4;

architecture arch_mux4 of mux4 is
begin
  b <= a1 when (sel = "00") else
       a2 when (sel = "01") else
       a3 when (sel = "10") else
       a4;
end arch_mux4;
