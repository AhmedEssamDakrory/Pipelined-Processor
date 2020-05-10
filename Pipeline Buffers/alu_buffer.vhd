LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY ALU_Buffer IS
 PORT(
    clk:IN STD_LOGIC;
    Load:IN STD_LOGIC;
    rst:IN STD_LOGIC;
    
    PcWrBack_in:in std_logic;
    Read_Sig_in:in std_logic;
    Write_sig_in:in std_logic;
    WbSig_in:in std_logic;
    MemToRegSig_in:in std_logic;
    OutPortSig_in:in std_logic;
    SwapSig_in:in std_logic;
    flagsOrSrc_in:in std_logic;
    DstAddress_in:in std_logic_vector (2 downto 0);
    Src1Address_in:in std_logic_vector (2 downto 0);
    flags_in:in std_logic_vector (2 downto 0);
    AluResult_in:in std_logic_vector (31 downto 0);
    Rsrc2_in:in std_logic_vector (31 downto 0);
    
    PcWrBack_out:out std_logic;
    Read_Sig_out:out std_logic;
    Write_Sig_out:out std_logic;
    WbSig_out:out std_logic;
    MemToRegSig_out:out std_logic;
    OutPortSig_out:out std_logic;
    SwapSig_out:out std_logic;
    flagsOrSrc_out:out std_logic;
    DstAddress_out:out std_logic_vector (2 downto 0);
    Src1Address_out:out std_logic_vector (2 downto 0);
    flags_out:out std_logic_vector (2 downto 0);
    AluResult_out:out std_logic_vector (31 downto 0);
    Rsrc2_out:out std_logic_vector (31 downto 0)
);
END ALU_Buffer;
ARCHITECTURE arch_alu_buffer OF ALU_Buffer IS

BEGIN
    process(clk, rst)
    begin
        if rst = '1' then
            PcWrBack_out <= '0' ;
            Read_Sig_out <= '0';
            Write_Sig_out <= '0';
            WbSig_out <= '0';
            MemToRegSig_out <= '0';
            OutPortSig_out <= '0';
            SwapSig_out <= '0';
            flagsOrSrc_out <= '0';
            DstAddress_out <= (others => '0');
            Src1Address_out <= (others => '0');
            flags_out <= (others => '0');
            AluResult_out <= (others => '0');
            Rsrc2_out <= (others => '0');
        elsif falling_edge(clk) then
            if Load = '1' then
                PcWrBack_out <= PcWrBack_in;
                Read_Sig_out <= Read_Sig_in;
                Write_Sig_out <= Write_Sig_in;
                WbSig_out <= WbSig_in;
                MemToRegSig_out <= MemToRegSig_in;
                OutPortSig_out <= OutPortSig_in;
                SwapSig_out <= SwapSig_in;
                flagsOrSrc_out <= flagsOrSrc_in;
                DstAddress_out <= DstAddress_in;
                Src1Address_out <= Src1Address_in;
                flags_out <= flags_in;
                AluResult_out <= AluResult_in;
                Rsrc2_out <= Rsrc2_in;
            end if;
        end if;
    end process;
END arch_alu_buffer;
