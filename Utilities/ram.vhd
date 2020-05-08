
-- Simple generic RAM Model

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity sync_ram is
  port (
    clk		: in  std_logic;
    we      : in  std_logic;	-- write = 1 , read = 0
	enable	: in  std_logic;
	ready 	: out std_logic;
    address : in  std_logic_vector(11 downto 0);
    datain  : in  std_logic_vector(127 downto 0);
    dataout : out std_logic_vector(127 downto 0)
  );
end entity sync_ram;

architecture RTL of sync_ram is

   type ram_type is array (0 to (2**12)) of std_logic_vector(15 Downto 0);
   -- signal read_address : std_logic_vector(11 downto 0);
   signal counter : std_logic_vector(1 downto 0) := "00";
	
   -- Init ram from file
   
   impure function init_ram (ram_file_name : in string) return ram_type is
   file ramfile : text is in ram_file_name;
   variable line_read : line;
   variable ram_to_return : ram_type;
   begin
	for i in ram_type'range loop
		if endfile(ramfile) then exit;
		end if;
		readline(ramfile, line_read);
		read(line_read, ram_to_return(i));
    end loop;
   return ram_to_return;
   end function;
   
   signal Ram : ram_type := init_ram("ram.dat");
  
begin

	process( clk ) begin
		if rising_edge(clk) then
			if enable = '1'  then
				counter <= std_logic_vector(unsigned(counter)+1);
			end if;
		end if;
	end process;


	process(clk) begin
		if rising_edge(clk) then
			if counter = "11" then
				if we = '1' then
					for k in 0 to 7 loop
						ram(to_integer(unsigned(address)) + k) <= datain((k+1)*16-1 downto k*16);
					end loop ;
				end if;
				ready <= '1';
				for k in 0 to 7 loop
					dataout((k+1)*16-1 downto k*16) <= ram(to_integer(unsigned(address)) + k);
				end loop ;
			else
				ready <= '0';
			end if;
		end if;
	end process ;


end architecture RTL;