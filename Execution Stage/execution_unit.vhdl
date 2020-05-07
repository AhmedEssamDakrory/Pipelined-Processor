library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;
entity Execution is
    port(
        Data1,Data2,RDestAlu,RDestMem,ImmConcatenate,RSrc2 : in std_logic_vector(31 downto 0);
        Operation : in std_logic_vector(4 downto 0);
        FlagsFromMem :in std_logic_vector(3 downto 0);
        ForwardData1,ForwardData2: in std_logic_vector(1 downto 0);
        clk :in std_logic;
        Extend : in std_logic;
        ALUWriteFlag: in std_logic;
        Taken : in std_logic;

        FlagOutput:out std_logic_vector(3 downto 0);
        Result,BrnchTakenOutput :out std_logic_vector(31 downto 0)
    );
end Execution;

architecture ExecutionArch of Execution is
    Signal A,B,Temp :std_logic_vector(31 downto 0);
    Signal FlagRegisterOutput,TempFlags :std_logic_vector(3 downto 0);
    Signal ResultSignal,Dummy1,Dummy2 : std_logic_vector (31 downto 0);
    begin
      Mux2_1 :entity work.Mux2(arch_mux2) generic map(N=>32) port map(Temp,ImmConcatenate,Extend,B);
      Mux2_2 :entity work.Mux2(arch_mux2) generic map(N=>32) port map(TempFlags,FlagsFromMem,ALUWriteFlag,FlagRegisterOutput);
      Mux2_3 :entity work.Mux2(arch_mux2) generic map(N=>32) port map(ResultSignal,RSrc2,Taken,BrnchTakenOutput);
      Mux4_1 :entity work.Mux4(arch_mux4) generic map(N=>32) port map(Data1,RDestAlu,RDestMem,Dummy1,ForwardData1,A);
      Mux4_2 :entity work.Mux4(arch_mux4) generic map(N=>32) port map(Data2,RDestAlu,RDestMem,Dummy2,ForwardData2,Temp);
      Reg  :entity work.Reg(arch_register) generic map(N=>4) port map(FlagRegisterOutput,'1','0',clk,FlagOutput);
      ALU :entity work.ALU(ALU_arcitecture) generic map(N=>32) port map(Operation,TempFlags,A,B,ResultSignal);
      Result<=ResultSignal;
      
end ExecutionArch;