LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY Decoding_Buffer IS
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
    ExtendSig_in:in std_logic;
    EAOrImmSig_in:in std_logic;
    JzSig_in:in std_logic;
    TakenSigForBranch_in:in std_logic;
    ALU_WrFlagSig_in:in std_logic;
    unCondSig_in:in std_logic;
    flagsOrSrc_in:in std_logic;
    typeOfInstr_in:in std_logic_vector (1 downto 0);
    opcode_in :in std_logic_vector (2 downto 0);
    Src1Address_in:in std_logic_vector (2 downto 0);
    Src2Address_in:in std_logic_vector (2 downto 0);
    DstAddress_in:in std_logic_vector (2 downto 0);
    EA_4_bits_in:in std_logic_vector (3 downto 0);
    data1_in:in std_logic_vector (31 downto 0);
    data2_in:in std_logic_vector (31 downto 0);
    
    PcWrBack_out                :out std_logic;
    Read_Sig_out                :out std_logic;
    Write_Sig_out               :out std_logic;
    WbSig_out                   :out std_logic;
    MemToRegSig_out             :out std_logic;
    OutPortSig_out              :out std_logic;
    SwapSig_out                 :out std_logic;
    ExtendSig_out               :out std_logic;
    EAOrImmSig_out              :out std_logic;
    JzSig_out                   :out std_logic;
    TakenSigForBranch_out       :out std_logic;
    ALU_WrFlagSig_out           :out std_logic;
    unCondSig_out               :out std_logic;
    flagsOrSrc_out              :out std_logic;
    typeOfInstr_out             :out std_logic_vector (1 downto 0);
    opcode_out                  :out std_logic_vector (2 downto 0);
    Src1Address_out             :out std_logic_vector (2 downto 0);
    Src2Address_out             :out std_logic_vector (2 downto 0);
    DstAddress_out              :out std_logic_vector (2 downto 0);
    EA_4_bits_out               :out std_logic_vector (3 downto 0);
    data1_out                   :out std_logic_vector (31 downto 0);
    data2_out                   :out std_logic_vector (31 downto 0)
);
END Decoding_Buffer;
ARCHITECTURE arch_Decoding_Buffer OF Decoding_Buffer IS

BEGIN
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PcWrBack_out <= '0' ;
                Read_Sig_out <= '0';
                Write_Sig_out <= '0';
                WbSig_out <= '0';
                MemToRegSig_out <= '0';
                OutPortSig_out <= '0';
                SwapSig_out <= '0';
                ExtendSig_out <= '0';
                EAOrImmSig_out <= '0';
                JzSig_out <= '0';
                TakenSigForBranch_out <= '0';
                ALU_WrFlagSig_out <= '0';
                unCondSig_out <= '0';
                flagsOrSrc_out <= '0';
                typeOfInstr_out <= (others => '0');
                opcode_out <= (others => '0');
                Src1Address_out <= (others => '0');
                Src2Address_out <= (others => '0');
                DstAddress_out <= (others => '0');
                EA_4_bits_out <= (others => '0');
                data1_out <= (others => '0');
                data2_out <= (others => '0');
            elsif Load = '1' then
                PcWrBack_out <= PcWrBack_in ;
                Read_Sig_out <= Read_Sig_in;
                Write_Sig_out <= Write_Sig_in;
                WbSig_out <= WbSig_in;
                MemToRegSig_out <= MemToRegSig_in;
                OutPortSig_out <= OutPortSig_in;
                SwapSig_out <= SwapSig_in;
                ExtendSig_out <= ExtendSig_in;
                EAOrImmSig_out <= EAOrImmSig_in;
                JzSig_out <= JzSig_in;
                TakenSigForBranch_out <= TakenSigForBranch_in;
                ALU_WrFlagSig_out <= ALU_WrFlagSig_in;
                unCondSig_out <= unCondSig_in;
                flagsOrSrc_out <= flagsOrSrc_in;
                typeOfInstr_out <= typeOfInstr_in;
                opcode_out <= opcode_in ;
                Src1Address_out <= Src1Address_in;
                Src2Address_out <= Src2Address_in;
                DstAddress_out <= DstAddress_in;
                EA_4_bits_out <= EA_4_bits_in;
                data1_out <= data1_in ;
                data2_out <= data2_in;
            end if;
        end if;
    end process;
END arch_Decoding_Buffer;


