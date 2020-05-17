library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity BranchPredictionBuffer is
  port (
    clk	    	  : in  std_logic;
    Instruction : in  std_logic_vector(4 downto 0);
    BranchPc    : in std_logic_vector(12 downto 0);
    input       : in  std_logic;	-- Taken = 1 , Not Taken = 0
    we,rst      : in std_logic; -- write 1 , read 0
    output      : out std_logic
  );
end entity BranchPredictionBuffer;

architecture ArchOfBranchPredictionBuffer of BranchPredictionBuffer is

   type ram_type is array (0 to (2**8)) of std_logic_vector(15 Downto 0);
   -- signal read_address : std_logic_vector(11 downto 0);
   signal PredictionBuffer : ram_type;
   signal fsm_output,fsm_input : integer range 0 to 3; 
   signal temp :std_logic_vector(15 downto 0);
   signal fsm_signal_output :std_logic;
  
begin
  FSM_Branch_prediction :entity work.FSM(moore) port map(input,clk,rst,we,BranchPc,fsm_input,fsm_output,fsm_signal_output);
  process(clk,BranchPc,input,PredictionBuffer,fsm_output,temp,rst,we)
  begin
    if rst='1' then
        PredictionBuffer<=(others=>X"0000");
    else
        if rising_edge(clk) then
          if (Instruction(4) and Instruction(3))='1' Then --Branch Instruction
            if we ='1' then
              if  PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)))=x"0000" and input='0' then
                  PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)))<="101"&BranchPc;
                  output<=PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)))(15);
              else
                 temp<=PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)));
                 fsm_input<=to_Integer(UNSIGNED(temp(14 downto 13)));
                 PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)))<=input&std_logic_vector(to_unsigned(fsm_output,2))&BranchPc;
                 output<=PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)))(15);
              end if;
            else
              output<= PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)))(15);
            end if;
          else
            output<='0';
          end if;
        end if;
    end if;
	end process;
end architecture ArchOfBranchPredictionBuffer;