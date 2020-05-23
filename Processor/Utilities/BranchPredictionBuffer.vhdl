library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity BranchPredictionBuffer is
  port (
    clk	    	  : in  std_logic;
    Instruction : in  std_logic_vector(4 downto 0);
    BranchPc    : in std_logic_vector(9 downto 0);
<<<<<<< HEAD
    input       : in  std_logic;	-- Taken = 1 , Not Taken = 0
=======
    inp       : in  std_logic;	-- Taken = 1 , Not Taken = 0
>>>>>>> 80fcfca288d5dec9372381e64f70d4f866cdcbed
    we,rst      : in std_logic; -- write 1 , read 0
    oup      : out std_logic
  );
end entity BranchPredictionBuffer;

architecture ArchOfBranchPredictionBuffer of BranchPredictionBuffer is

   type ram_type is array (0 to (2**10)) of std_logic_vector(2 Downto 0);
   -- signal read_address : std_logic_vector(11 downto 0);
   signal PredictionBuffer : ram_type := (others=>"101") ;
   signal fsm_output,fsm_input : integer range 0 to 3; 
   signal temp :std_logic_vector(2 downto 0);
   signal fsm_signal_output :std_logic;

   signal enable :std_logic;
begin
<<<<<<< HEAD
  FSM_Branch_prediction :entity work.FSM(moore) port map(input,clk,rst,we,fsm_input,fsm_output,fsm_signal_output);
  process(clk,BranchPc,input,PredictionBuffer,fsm_output,temp,rst,we,Instruction,fsm_signal_output)
  begin
    if rst='1' then
        PredictionBuffer<=(others=>"000");
    else
        if rising_edge(clk) then
          if (Instruction(4) and Instruction(3))='1' Then --Branch Instruction
            if we ='1' then
              if  PredictionBuffer(to_integer(UNSIGNED(BranchPc)))="000" and input='0' then
                  PredictionBuffer(to_integer(UNSIGNED(BranchPc)))<="101";
                  output<=PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)))(2);
              else
                 temp<=PredictionBuffer(to_integer(UNSIGNED(BranchPc)));
                 fsm_input<=to_Integer(UNSIGNED(temp(1 downto 0)));
                 PredictionBuffer(to_integer(UNSIGNED(BranchPc)))<=fsm_signal_output&std_logic_vector(to_unsigned(fsm_output,2));
                 output<=PredictionBuffer(to_integer("000"&UNSIGNED(BranchPc)))(2);
              end if;
            else
              output<= PredictionBuffer(to_integer(UNSIGNED(BranchPc)))(2);
            end if;
          else
            output<='0';
          end if;
        end if;
    end if;
	end process;
=======
  FSM_Branch_prediction :entity work.FSM(moore) port map(inp,clk,rst,we,fsm_input,fsm_output,fsm_signal_output);
  enable <= '1' when (Instruction(4) and Instruction(3))='1' else '0';
  temp   <= PredictionBuffer(to_integer(UNSIGNED(BranchPc))) when enable='1' else "ZZZ";
  fsm_input <= to_Integer(UNSIGNED(temp(1 downto 0))) when enable='1' else 0;
  PredictionBuffer(to_integer(UNSIGNED(BranchPc)))<=fsm_signal_output&std_logic_vector(to_unsigned(fsm_output,2)) when enable='1' else "ZZZ";
  oup<=fsm_signal_output when enable='1' else 'Z';
>>>>>>> 80fcfca288d5dec9372381e64f70d4f866cdcbed
end architecture ArchOfBranchPredictionBuffer;