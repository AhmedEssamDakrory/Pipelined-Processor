LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY ControlUnit IS
 PORT(
    clk 				: IN STD_LOGIC;
	clr 				: IN STD_LOGIC;
	instr_type			: IN STD_LOGIC_VECTOR(1 downto 0);
	op_code				: IN STD_LOGIC_VECTOR(2 downto 0);
	int					: IN STD_LOGIC;
	
	sub					: OUT STD_LOGIC;
	ea_immediate		: OUT STD_LOGIC;
	mem_read			: OUT STD_LOGIC;
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
	enable				: OUT STD_LOGIC
	
);
END ControlUnit;
ARCHITECTURE arch OF ControlUnit IS
COMPONENT FlipFlop IS
 PORT(
    Load  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
	d   : IN STD_LOGIC;
    q   : OUT STD_LOGIC
);
END COMPONENT;
	
SIGNAL rti, enbl, int_out, rti_out, enbl_out, pc_disbale_sig, counter_rst	: STD_LOGIC;
SIGNAL counter																: STD_LOGIC_VECTOR(1 downto 0);

BEGIN
	interrupt_reg 	: FlipFlop generic map(1) port map(int, clr, clk, int, int_out);
	rti_reg			: FlipFlop generic map(1) port map(rti, clr, clk, rti, rti_out);
	enable_reg		: FlipFlop generic map(1) port map(enbl, clr, clk, enbl, enbl_out);
	-- Register Signals
	rti 				<= '1' when op_code = "100" and instr_type = "11" else '0';
	enbl 				<= int or rti;
	-- Control signals
	sub					<= '1' when (op_code = "011" and instr_type = "11") or (op_code = "000" and instr_type = "10") or int_out = '1' else '0';
	ea_immediate		<= '1' when (op_code = "011" or op_code = "100" ) and instr_type = "10" else '0';
	mem_read			<= '1' when (op_code = "100" and instr_type = "10") or ((op_code = "001" or op_code = "101") and instr_type = "11") or rti_out = '1' else '0';
	push_pop			<= '1' when op_code = "000" and instr_type = "10" else '0';
	jz					<= '1' when op_code = "000" and instr_type = "11" else '0'; 
	jmp					<= '1' when op_code = "001" and instr_type = "11" else '0';
	pc_inc				<= '1' when (op_code = "000" or op_code = "010") and instr_type = "11" else '0';
	pc_write_back		<= '1' when ((op_code = "011" or op_code = "010") and instr_type = "11") or rti_out = '1' else '0';
	counter_rst			<= '1' when ((op_code = "011" or op_code = "010" or op_code = "100") and instr_type = "11") or int = '1' else '0';
	src1				<= '1' when instr_type = "01" or (op_code = "101" and instr_type = "00") or ((op_code = "001" or op_code = "000" ) and instr_type = "11") else '0';
	src2				<= '1' when instr_type = "01" else '0';
	select_in			<= '1' when op_code = "101" and instr_type = "00" else '0';
	swap				<= '1' when op_code = "000" and instr_type = "01" else '0';
	mem_to_reg			<= '1' when instr_type = "01" or instr_type = "10" else '0';
	write_back			<= '1' when instr_type = "01" or (instr_type = "10" and (op_code = "001" or op_code = "010" or op_code = "011")) else '0';
	out_port			<= '1' when op_code = "100" and instr_type = "00" else '0';
	enable				<= '1' when int = '1' or enbl_out = '1' or (instr_type = "10" and (op_code = "000" or op_code = "001") ) or (instr_type = "11" and (op_code = "100" or op_code = "011")) else '0'; 
	flags				<= int_out;
	flags_write_back	<= rti_out;
	pc_disbale 			<= pc_disbale_sig;
	-- Flush counter
	PROCESS (pc_disbale_sig, clk, counter_rst, counter) 	
	BEGIN   	
	    if (counter_rst = '1') then
			counter <= "00";
			pc_disbale_sig <= '1';
		elsif(counter = "10") then
			pc_disbale_sig <= '0';
	    elsif (pc_disbale_sig = '1' and rising_edge(clk)) then 
			counter <= counter + 1;
			pc_disbale_sig <= '1';
	    end if;     
		
	END PROCESS;
END arch;
