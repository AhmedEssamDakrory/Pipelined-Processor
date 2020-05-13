LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Mem_Buffer IS
 PORT(
    clk:IN STD_LOGIC;
    Load:IN STD_LOGIC;
    rst:IN STD_LOGIC;
    
    PcWrBack_in:in std_logic;
    WbSig_in:in std_logic;
    MemToRegSig_in:in std_logic;
    OutPortSig_in:in std_logic;
    SwapSig_in:in std_logic;
    DstAddress_in:in std_logic_vector (2 downto 0);
    Src1Address_in:in std_logic_vector (2 downto 0);
    AluResult_in:in std_logic_vector (31 downto 0);
    DataFromMem_in:in std_logic_vector (31 downto 0);
    
    PcWrBack_out:out std_logic;
    WbSig_out:out std_logic;
    MemToRegSig_out:out std_logic;
    OutPortSig_out:out std_logic;
    SwapSig_out:out std_logic;
    DstAddress_out:out std_logic_vector (2 downto 0);
    Src1Address_out:out std_logic_vector (2 downto 0);
    AluResult_out:out std_logic_vector (31 downto 0);
    DataFromMem_out:out std_logic_vector (31 downto 0)
);
END Mem_Buffer;
ARCHITECTURE arch_mem_buffer OF Mem_Buffer IS

BEGIN
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PcWrBack_out <= '0' ;
                WbSig_out <= '0';
                MemToRegSig_out <= '0';
                OutPortSig_out <= '0';
                SwapSig_out <= '0';
                DstAddress_out <= (others => '0');
                Src1Address_out <= (others => '0');
                AluResult_out <= (others => '0');
                DataFromMem_out <= (others => '0');
            elsif Load = '1' then
                PcWrBack_out <= PcWrBack_in ;
                WbSig_out <= WbSig_in;
                MemToRegSig_out <= MemToRegSig_in;
                OutPortSig_out <= OutPortSig_in;
                SwapSig_out <= SwapSig_in;
                DstAddress_out <= DstAddress_in;
                Src1Address_out <= Src1Address_in;
                AluResult_out <= AluResult_in;
                DataFromMem_out <= DataFromMem_in;
            end if;
        end if;
    end process;
END arch_mem_buffer;
