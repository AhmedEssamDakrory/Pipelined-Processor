
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity cache is
generic (N : Integer := 32);
port (
    clock   : in  std_logic;
    we      : in  std_logic;
    index 	: in  std_logic_vector(4 downto 0);
	offset	: in  std_logic_vector(2 downto 0);
    datain  : in  std_logic_vector(N-1 downto 0);
    dataout : out std_logic_vector(N-1 downto 0)
  );
end entity cache;

architecture RTL of cache is

   type cache_type is array (0 to 31) of std_logic_vector(127 Downto 0);
   signal cache_mem : cache_type;
   
begin

  process(index , offset , datain , we) is

  begin
      if we = '1' then
        cache_mem(to_integer(unsigned(index))) (to_integer(unsigned(offset)) + N Downto  to_integer(unsigned(offset))) <= datain;
      end if;
  end process;

  dataout <= cache_mem(to_integer(unsigned(index))) (to_integer(unsigned(offset)) + N Downto  to_integer(unsigned(offset)));

end architecture RTL;