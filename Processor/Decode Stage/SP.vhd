LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Reg_SP IS
 generic (N : Integer := 32);
 PORT(
    Load  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
	d   : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    q   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) 
);
END Reg_SP;
ARCHITECTURE arch_register OF Reg_SP IS

BEGIN
    process(clk)
    begin
        if rising_edge(clk) then
            if clr = '1' then
                q <= "11111111111111111111111111111110";
            elsif Load = '1' then
                q <= d;
            end if;
        end if;
    end process;
END arch_register;
