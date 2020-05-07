LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Reg IS
 generic (N : Integer := 32);
 PORT(
    Load  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
	d   : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    q   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) 
);
END Reg;
ARCHITECTURE arch_register OF Reg IS

BEGIN
    process(clk, clr)
    begin
        if clr = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if Load = '1' then
                q <= d;
            end if;
        end if;
    end process;
END arch_register;
