LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
ENTITY DecodeStage IS
 PORT(
	clk 				: IN STD_LOGIC;
	clr 				: IN STD_LOGIC;
	instr_type			: IN STD_LOGIC_VECTOR(1 downto 0);
	op_code				: IN STD_LOGIC_VECTOR(2 downto 0);
	int					: IN STD_LOGIC;
	stall_sp            : IN STD_LOGIC;
	out_port_write      : in std_logic;
	
	disable				: IN STD_LOGIC;
	address1			: IN STD_LOGIC_VECTOR(2 downto 0);
	address2			: IN STD_LOGIC_VECTOR(2 downto 0);
	write_address1		: IN STD_LOGIC_VECTOR(2 downto 0);
	write_address2		: IN STD_LOGIC_VECTOR(2 downto 0);
	dest				: IN STD_LOGIC_VECTOR(2 downto 0);
	write_reg1			: IN STD_LOGIC;
	write_reg2			: IN STD_LOGIC;
	write_data1			: IN STD_LOGIC_VECTOR(31 downto 0);
	write_data2			: IN STD_LOGIC_VECTOR(31 downto 0);
	PC					: IN STD_LOGIC_VECTOR(31 downto 0);
	port_in				: IN STD_LOGIC_VECTOR(31 downto 0);
	
	data1				: OUT STD_LOGIC_VECTOR(31 downto 0);
	data2				: OUT STD_LOGIC_VECTOR(31 downto 0);
	Rdst				: OUT STD_LOGIC_VECTOR(31 downto 0);
	port_out			: OUT STD_LOGIC_VECTOR(31 downto 0);
	sub					: OUT STD_LOGIC;
	ea_immediate		: OUT STD_LOGIC;
	mem_read			: OUT STD_LOGIC;
	mem_write			: OUT STD_LOGIC;
	push_pop			: OUT STD_LOGIC;
	jz					: OUT STD_LOGIC;
	jmp					: OUT STD_LOGIC;
	flags				: OUT STD_LOGIC;
	flags_write_back	: OUT STD_LOGIC;
	pc_inc				: OUT STD_LOGIC;
	pc_write_back		: OUT STD_LOGIC;
	pc_disbale			: OUT STD_LOGIC; -- Flush fetch
	src1				: OUT STD_LOGIC;
	src2				: OUT STD_LOGIC;
	select_in			: OUT STD_LOGIC;
	swap				: OUT STD_LOGIC; -- Write register 2
	mem_to_reg			: OUT STD_LOGIC;
	write_back			: OUT STD_LOGIC;
	out_port			: OUT STD_LOGIC;
	enable				: OUT STD_LOGIC;
	int_out				: OUT STD_LOGIC
	
);
END DecodeStage;
ARCHITECTURE arch OF DecodeStage IS
	COMPONENT Reg IS
	GENERIC (N : Integer := 32);
	PORT(
		load  		: IN STD_LOGIC;
		clr 		: IN STD_LOGIC;
		clk 		: IN STD_LOGIC;
		d   		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		q   		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) 
	);
	END COMPONENT;
	
	COMPONENT Reg_SP IS
	GENERIC (N : Integer := 32);
	PORT(
		load  		: IN STD_LOGIC;
		clr 		: IN STD_LOGIC;
		clk 		: IN STD_LOGIC;
		d   		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		q   		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) 
	);
	END COMPONENT;
	
	COMPONENT ControlUnit IS
	PORT(
		clk 				: IN STD_LOGIC;
		clr 				: IN STD_LOGIC;
		stall   : IN STD_LOGIC;
		instr_type			: IN STD_LOGIC_VECTOR(1 downto 0);
		op_code				: IN STD_LOGIC_VECTOR(2 downto 0);
		int					: IN STD_LOGIC;
		
		sub					: OUT STD_LOGIC;
		ea_immediate		: OUT STD_LOGIC;
		mem_read			: OUT STD_LOGIC;
		mem_write			: OUT STD_LOGIC;
		push_pop			: OUT STD_LOGIC;
		jz					: OUT STD_LOGIC;
		jmp					: OUT STD_LOGIC;
		flags				: OUT STD_LOGIC;
		flags_write_back	: OUT STD_LOGIC;
		pc_inc				: OUT STD_LOGIC;
		pc_write_back		: OUT STD_LOGIC;
		pc_disbale			: OUT STD_LOGIC; -- Flush fetch
		src1				: OUT STD_LOGIC;
		src2				: OUT STD_LOGIC;
		select_in			: OUT STD_LOGIC;
		swap				: OUT STD_LOGIC; -- Write register 2
		mem_to_reg			: OUT STD_LOGIC;
		write_back			: OUT STD_LOGIC;
		out_port			: OUT STD_LOGIC;
		enable				: OUT STD_LOGIC;
		int_sig   			: OUT STD_LOGIC;
		rti_sig				: OUT STD_LOGIC
		
	);
	END COMPONENT;
	COMPONENT RegisterFile IS
	PORT(
		clk 			: IN STD_LOGIC;
		clr 			: IN STD_LOGIC;
		address1		: IN STD_LOGIC_VECTOR(2 downto 0);
		address2		: IN STD_LOGIC_VECTOR(2 downto 0);
		write_address1	: IN STD_LOGIC_VECTOR(2 downto 0);
		write_address2	: IN STD_LOGIC_VECTOR(2 downto 0);
		dest			: IN STD_LOGIC_VECTOR(2 downto 0);
		write_reg1		: IN STD_LOGIC;
		write_reg2		: IN STD_LOGIC;
		write_data1		: IN STD_LOGIC_VECTOR(31 downto 0);
		write_data2		: IN STD_LOGIC_VECTOR(31 downto 0);
		
		data1			: OUT STD_LOGIC_VECTOR(31 downto 0);
		data2			: OUT STD_LOGIC_VECTOR(31 downto 0);
		Rdst			: OUT STD_LOGIC_VECTOR(31 downto 0)
		
	);
	END COMPONENT;
	COMPONENT Adder IS
    PORT (
        clk     : in std_logic;
        rst     : in std_logic;
		enbl    : in std_logic;
        add_sub : in std_logic; -- add = 0, sub = 1
        in_a    : in std_logic_vector(31 downto 0);
        in_b    : in std_logic_vector(31 downto 0);

        out_c   : out std_logic_vector(31 downto 0)
    );
	END COMPONENT;
	COMPONENT Mux2 IS
	GENERIC (N : Integer := 32);
	PORT(
	  a1      : in  std_logic_vector(N-1 downto 0);
	  a2      : in  std_logic_vector(N-1 downto 0);
	  sel     : in  std_logic;
	  b       : out std_logic_vector(N-1 downto 0));
	END COMPONENT;
	
	SIGNAl SP_load, in_load : STD_LOGIC := '1';
	SIGNAl add_sig, rst	: STD_LOGIC := '0';
	-- Control signals
	SIGNAl sub_sig, ea_immediate_sig, mem_read_sig, mem_write_sig, push_pop_sig, jz_sig, jmp_sig, flags_sig, 
		   flags_write_back_sig, pc_inc_sig, pc_write_back_sig, pc_disbale_sig, src1_sig, src2_sig,
		   select_in_sig, swap_sig, mem_to_reg_sig, write_back_sig, out_port_sig,enable_sig,int_sig, rti_sig :STD_LOGIC;
	
	SIGNAl data1_sig, data2_sig, PC_out, PC_incremented,in_port_out, out_port_out, SP_curr,
		   SP_in, SP_out, temp : STD_LOGIC_VECTOR(31 downto 0);
	SIGNAl one : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000001";
	SIGNAl two : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000010";
	signal not_clk: std_logic;
BEGIN
	not_clk<=not clk;
	control_unit	: ControlUnit port map (clk, clr, stall_sp , instr_type, op_code, int,  sub_sig, ea_immediate_sig, 
											mem_read_sig, mem_write_sig, push_pop_sig, jz_sig, jmp_sig, flags_sig, flags_write_back_sig, 
											pc_inc_sig, pc_write_back_sig, pc_disbale_sig, src1_sig, src2_sig, select_in_sig,
											swap_sig, mem_to_reg_sig, write_back_sig, out_port_sig, enable_sig , int_sig);
	register_file	: RegisterFile port map (not_clk, clr, address1, address2, write_address1, write_address2,	dest, 
											write_reg1, write_reg2, write_data1, write_data2, data1_sig, data2_sig, Rdst);
	
	stack_pointer 	: Reg_SP port map(SP_load, clr, clk, SP_in, SP_curr);
	input_port 		: Reg port map(in_load, clr, not_clk, port_in, in_port_out);
	output_port 	: Reg port map(out_port_write, clr, not_clk, write_data1, port_out);
	
	pass_inc_sp		: Mux2 port map(SP_in, SP_curr, push_pop_sig, SP_out);
	
	PC_incremented <= std_logic_vector(unsigned(PC) + unsigned(one));
	pass_inc_pc		: Mux2 port map(PC, PC_incremented, pc_inc_sig, PC_out);
	
	data1_sp		: Mux2 port map(SP_out, data1_sig, src1_sig,temp);
	in_data1_sp		: Mux2 port map(temp, in_port_out, select_in_sig, data1);
	pc_data2		: Mux2 port map(PC_out, data2_sig, src2_sig, data2);
	
	sub					<= sub_sig and not disable;
	ea_immediate		<= ea_immediate_sig and not disable;
	mem_read			<= mem_read_sig and not disable;
	mem_write			<= mem_write_sig and not disable;
	push_pop			<= push_pop_sig and not disable;
	jz					<= jz_sig and not disable;
	jmp					<= jmp_sig and not disable;
	flags				<= flags_sig and not disable;
	flags_write_back	<= flags_write_back_sig and not disable;
	pc_inc				<= pc_inc_sig and not disable;
	pc_write_back		<= pc_write_back_sig and not disable;
	pc_disbale			<= pc_disbale_sig and not disable;
	src1				<= src1_sig and not disable and not int;
	src2				<= src2_sig and not disable and not int;
	select_in			<= select_in_sig and not disable and not int;
	swap				<= swap_sig and not disable and not int;
	mem_to_reg			<= mem_to_reg_sig and not disable and not int;
	write_back			<= write_back_sig and not disable and not int;
	out_port			<= out_port_sig and not disable and not int;
	enable				<= enable_sig and not disable and not int;
	SP_load				<= '1' when (int = '1' or int_sig = '1'  or rti_sig = '1') or (stall_sp = '1' and ( ((op_code = "000" or op_code = "001") and instr_type = "10") or ((op_code = "010" or op_code = "011" or op_code = "100") and instr_type = "11") )) else '0';
	
	-- Adder/Subtractor of stack pointer
	PROCESS (sub_sig, SP_load, op_code, instr_type, SP_curr, clr) 	
	BEGIN
		if(sp_load = '1') then
			 if (sub_sig = '1') then
					SP_in <= std_logic_vector(unsigned(SP_curr) + unsigned(std_logic_vector(unsigned(not(two)) + 1)));
			else
					SP_in <= std_logic_vector(unsigned(SP_curr) + unsigned(two));
			end if;     
		end if;
		
	   
	END PROCESS;
	int_out <= int or int_sig;
END arch;

