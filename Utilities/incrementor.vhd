LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
entity Inc is
generic (N : Integer := 32);
port(
input: in std_logic_vector(N-1 downto 0);
output: out std_logic_vector(N-1 downto 0)
);
end Inc;

architecture arch_inc of Inc is
signal c : std_logic_vector(N-1 downto 0);
begin
c(0) <= '1';
output(0) <= c(0) xor input(0);
gen_inc:
for i in 1 to N-1 generate
  gen1: c(i) <= input(i-1) and c(i-1);
  gen2: output(i) <= c(i) xor input(i);
end generate gen_inc;
end arch_inc;
