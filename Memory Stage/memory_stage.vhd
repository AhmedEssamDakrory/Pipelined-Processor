library IEEE;
use IEEE.std_logic_1164.all;

entity memory_stage is
  
port(
	flags_src, swap								: in	std_logic;
	to_mem, data								: out	std_logic_vector(31 downto 0);
	Rsrc2_in,from_mem							: in	std_logic_vector(31 downto 0);
	flags										: in	std_logic_vector(2 downto 0)
  );
end memory_stage;

architecture structural of memory_stage is

	
begin
	
	to_mem <= Rsrc2_in when flags_src = '1' else 
				"00000000000000000000000000000"& flags;
	 
	data <= from_mem when swap = '0' else
				Rsrc2_in;
				
end structural;