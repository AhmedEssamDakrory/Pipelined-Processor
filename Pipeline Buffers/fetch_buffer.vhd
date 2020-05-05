LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Fetch_Buffer IS
 PORT(
    clk : IN STD_LOGIC;
    Load  : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    
    instr_in:IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    pc_in:IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    disableForImmediate_in:IN STD_LOGIC;
    takenSigForBranch_in:IN STD_LOGIC;
    
    instr_out:out STD_LOGIC_VECTOR(15 DOWNTO 0);
    pc_out:out STD_LOGIC_VECTOR(31 DOWNTO 0);
    disableForImmediate_out:out STD_LOGIC;
    takenSigForBranch_out:out STD_LOGIC 
);
END Fetch_Buffer;
ARCHITECTURE arch_fetch_buffer OF Fetch_Buffer IS

BEGIN
    process(clk, rst)
    begin
        if rst = '1' then
            instr_out <= (others => '0');
            pc_out <= (others => '0');
            disableForImmediate_out <= '0';
            takenSigForBranch_out <= '0';
        elsif falling_edge(clk) then
            if Load = '1' then
                instr_out <= instr_in;
                pc_out <= pc_in;
                disableForImmediate_out <= disableForImmediate_in;
                takenSigForBranch_out <= takenSigForBranch_in; 
            end if;
        end if;
    end process;
END arch_fetch_buffer;


