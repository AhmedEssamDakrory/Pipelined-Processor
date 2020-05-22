library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity BranchPredictionBuffer is
  port (
    clk	    	  : in  std_logic;
    Instruction : in  std_logic_vector(4 downto 0);
    BranchPc    : in std_logic_vector(9 downto 0);
    inp       : in  std_logic;	-- Taken = 1 , Not Taken = 0
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
  FSM_Branch_prediction :entity work.FSM(moore) port map(inp,clk,rst,we,fsm_input,fsm_output,fsm_signal_output);
  enable <= '1' when (Instruction(4) and Instruction(3))='1' else '0';
  temp   <= PredictionBuffer(to_integer(UNSIGNED(BranchPc))) when enable='1' else "ZZZ";
  fsm_input <= to_Integer(UNSIGNED(temp(1 downto 0))) when enable='1' else 0;
  PredictionBuffer(to_integer(UNSIGNED(BranchPc)))<=fsm_signal_output&std_logic_vector(to_unsigned(fsm_output,2)) when enable='1' else "ZZZ";
  oup<=fsm_signal_output when enable='1' else 'Z';
end architecture ArchOfBranchPredictionBuffer;