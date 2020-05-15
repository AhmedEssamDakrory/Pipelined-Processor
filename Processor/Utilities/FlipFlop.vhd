LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY FlipFlop IS
 PORT(
    Load  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
	d   : IN STD_LOGIC;
    q   : OUT STD_LOGIC
);
END FlipFlop;
ARCHITECTURE arch OF FlipFlop IS

BEGIN
    process(clk, clr)
    begin
        if clr = '1' then
            q <= '0';
        elsif rising_edge(clk) then
            if Load = '1' then
                q <= d;
            end if;
        end if;
    end process;
END arch;

