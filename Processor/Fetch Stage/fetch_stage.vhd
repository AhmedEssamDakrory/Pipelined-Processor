library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity fetch_stage is
  
port(
	clk, rst 																			: in 	std_logic;
	disable1, disable2, disable3,disable4,disable5										: in 	std_logic;
	taken_sel,wrong_pred_sel,write_back_sel												: in	std_logic;
	Rdest_sel																			: in	std_logic_vector(2 downto 0);
	Rdest_mem,Rdest_alu,Rdest_decode,R_alternative,R_writeback,Src1_Alu,Src1_mem		: in 	std_logic_vector(31 downto 0);
	pc																					: out	std_logic_vector(31 downto 0)	
	
  );
end fetch_stage;

architecture structural of fetch_stage is
	
	component Reg IS
	generic (N : Integer := 32);
	PORT(
    Load  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
	d   : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    q   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) 
		);
	end component;
	
	signal R1,R2,R3,R4,pc_inc,temp_pc						:	std_logic_vector(31 downto 0);
	signal enable											:	std_logic;
	
begin
	pc_reg	:	reg port map(enable, rst, clk, R4, temp_pc);

	pc <= temp_pc;
	
	R1 <= Rdest_mem when Rdest_sel = "010" else 
			Rdest_alu when Rdest_sel = "001"  else
			Src1_Alu when Rdest_sel = "100"  else
			Src1_mem when Rdest_sel = "011"  else
			Rdest_decode;
	
	R2	<= R1 when taken_sel = '1' else
			pc_inc;
			
	R3 <= R2 when wrong_pred_sel = '0' else
			R_alternative;
			
	R4 <= R3 when write_back_sel = '0' else
				R_writeback	;
				
	enable <= not (disable1 or disable2 or disable3 or disable4 or disable5);
	pc_inc <= std_logic_vector( unsigned(temp_pc) + 1 );

end structural;