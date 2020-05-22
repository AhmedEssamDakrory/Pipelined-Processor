LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity ALU_Forwarding_Unit is
port(
oper : in std_logic_vector(4 downto 0);
src1:in std_logic_vector(2 downto 0);
src2:in std_logic_vector(2 downto 0);
src1_mem:in std_logic_vector(2 downto 0);
dst_mem:in std_logic_vector(2 downto 0);
src1_alu:in std_logic_vector(2 downto 0);
dst_alu:in std_logic_vector(2 downto 0);
wb_mem:in std_logic;
wb_alu:in std_logic;
swap_mem:in std_logic;
swap_alu:in std_logic;
src1_sel:out std_logic_vector (2 downto 0); 
src2_sel:out std_logic_vector (2 downto 0)
);
end ALU_Forwarding_Unit;

architecture arch_alu_forwarding_unit of ALU_Forwarding_Unit is
begin
src1_sel <= "000" when (oper = "00101" or oper = "10000") else
			"001" when ( (src1 = dst_alu) and (wb_alu = '1') ) else
			"100" when ( (src1 = src1_alu) and (swap_alu = '1')) else
			"010" when ( (src1 = dst_mem) and (wb_mem = '1')) else
			"011" when ( (src1 = src1_mem) and (swap_mem = '1')) else
			"000";
			
src2_sel <= "000" when (oper = "00101") else
			"001" when ( (src2 = dst_alu) and (wb_alu = '1') ) else
			"100" when ( (src2 = src1_alu) and (swap_alu = '1')) else
			"010" when ( (src2 = dst_mem) and (wb_mem = '1')) else
			"011" when ( (src2 = src1_mem) and (swap_mem = '1')) else
			"000";

end arch_alu_forwarding_unit;

--selectors...

-- [ 000 sel data1 ]... 
--[ 001 sel dest_alu(result) ]... 
--[ 010 sel dest_mem(mem_result) ]...
--[ 100 sel src1_alu(R[src2]_alu) ]...
--[ 011 sel src1_mem (R[src2_mem])]...



