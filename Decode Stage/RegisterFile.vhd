LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY RegisterFile IS
 PORT(
    clk 			: IN STD_LOGIC;
	clr 			: IN STD_LOGIC;
	address1		: IN STD_LOGIC_VECTOR(2 downto 0);
	address2		: IN STD_LOGIC_VECTOR(2 downto 0);
	write_address1	: IN STD_LOGIC_VECTOR(2 downto 0);
	write_address2	: IN STD_LOGIC_VECTOR(2 downto 0);
	write_reg1		: IN STD_LOGIC;
	write_reg2		: IN STD_LOGIC;
	write_data1		: IN STD_LOGIC_VECTOR(31 downto 0);
	write_data2		: IN STD_LOGIC_VECTOR(31 downto 0);
	data1			: OUT STD_LOGIC_VECTOR(31 downto 0);
	data2			: OUT STD_LOGIC_VECTOR(31 downto 0)
	
);
END RegisterFile;
ARCHITECTURE arch OF RegisterFile IS
	COMPONENT Reg IS
	 generic (N : Integer := 32);
	 PORT(
		load  		: IN STD_LOGIC;
		clr 		: IN STD_LOGIC;
		clk 		: IN STD_LOGIC;
		d   		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		q   		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0) 
	);
	END COMPONENT;
	SIGNAl in0, in1, in2, in3, in4, in5, in6, in7: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAl out0, out1, out2, out3, out4, out5, out6, out7: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAl load0, load1, load2, load3, load4, load5, load6, load7: STD_LOGIC := '0';
	

BEGIN
	-- Registers
	R0 : Reg port map(load0, clr, clk, in0, out0);
	R1 : Reg port map(load1, clr, clk, in1, out1);
	R2 : Reg port map(load2, clr, clk, in2, out2);
	R3 : Reg port map(load3, clr, clk, in3, out3);
	R4 : Reg port map(load4, clr, clk, in4, out4);
	R5 : Reg port map(load5, clr, clk, in5, out5);
	R6 : Reg port map(load6, clr, clk, in6, out6);
	R7 : Reg port map(load7, clr, clk, in7, out7);
	
	data1 <= out0 when address1 = "000" else
			 out1 when address1 = "001" else
			 out2 when address1 = "010" else
			 out3 when address1 = "011" else
			 out4 when address1 = "100" else
			 out5 when address1 = "101" else
			 out6 when address1 = "110" else
			 out7;
	data2 <= out0 when address2 = "000" else
			 out1 when address2 = "001" else
			 out2 when address2 = "010" else
			 out3 when address2 = "011" else
			 out4 when address2 = "100" else
			 out5 when address2 = "101" else
			 out6 when address2 = "110" else
			 out7;
			 
	-- Write Back
	load0 <= '1' when (write_reg1 = '1' and write_address1 = "000") or (write_reg2 = '1' and write_address2 = "000") else '0';
	load1 <= '1' when (write_reg1 = '1' and write_address1 = "001") or (write_reg2 = '1' and write_address2 = "001") else '0';
	load2 <= '1' when (write_reg1 = '1' and write_address1 = "010") or (write_reg2 = '1' and write_address2 = "010") else '0';
	load3 <= '1' when (write_reg1 = '1' and write_address1 = "011") or (write_reg2 = '1' and write_address2 = "011") else '0';
	load4 <= '1' when (write_reg1 = '1' and write_address1 = "100") or (write_reg2 = '1' and write_address2 = "100") else '0';
	load5 <= '1' when (write_reg1 = '1' and write_address1 = "101") or (write_reg2 = '1' and write_address2 = "101") else '0';
	load6 <= '1' when (write_reg1 = '1' and write_address1 = "110") or (write_reg2 = '1' and write_address2 = "110") else '0';
	load7 <= '1' when (write_reg1 = '1' and write_address1 = "111") or (write_reg2 = '1' and write_address2 = "111") else '0';
	
	in0 <= write_data1 when write_reg1 = '1' and write_address1 = "000";
	in1 <= write_data1 when write_reg1 = '1' and write_address1 = "001";
	in2 <= write_data1 when write_reg1 = '1' and write_address1 = "010";
	in3 <= write_data1 when write_reg1 = '1' and write_address1 = "011";
	in4 <= write_data1 when write_reg1 = '1' and write_address1 = "100";
	in5 <= write_data1 when write_reg1 = '1' and write_address1 = "101";
	in6 <= write_data1 when write_reg1 = '1' and write_address1 = "110";
	in7 <= write_data1 when write_reg1 = '1' and write_address1 = "111";

	in0 <= write_data2 when write_reg2 = '1' and write_address2 = "000";
	in1 <= write_data2 when write_reg2 = '1' and write_address2 = "001";
	in2 <= write_data2 when write_reg2 = '1' and write_address2 = "010";
	in3 <= write_data2 when write_reg2 = '1' and write_address2 = "011";
	in4 <= write_data2 when write_reg2 = '1' and write_address2 = "100";
	in5 <= write_data2 when write_reg2 = '1' and write_address2 = "101";
	in6 <= write_data2 when write_reg2 = '1' and write_address2 = "110";
	in7 <= write_data2 when write_reg2 = '1' and write_address2 = "111";
	
END arch;
