LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Fetch_Forwarding_Unit is
port(
dst_branch:in std_logic_vector(2 downto 0);
src1_mem:in std_logic_vector(2 downto 0);
dst_mem:in std_logic_vector(2 downto 0);
src1_alu:in std_logic_vector(2 downto 0);
dst_alu:in std_logic_vector(2 downto 0);
wb_mem:in std_logic;
wb_alu:in std_logic;
swap_mem:in std_logic;
swap_alu:in std_logic; 
dst_sel:out std_logic_vector (2 downto 0)
);
end Fetch_Forwarding_Unit;

architecture arch_fetch_forwarding_unit of Fetch_Forwarding_Unit is
begin
dst_sel <= "001" when ( (dst_branch = dst_alu) and (wb_alu = '1') ) else
			"100" when ( (dst_branch = src1_alu) and (swap_alu = '1')) else
			"010" when ( (dst_branch = dst_mem) and (wb_mem = '1')) else
			"011" when ( (dst_branch = src1_mem) and (swap_mem = '1')) else
			"000";

end arch_fetch_forwarding_unit;

--selectors...

-- [ 000 sel data_dec ]... 
--[ 001 sel dest_alu(result) ]... 
--[ 010 sel dest_mem(mem_result) ]...
--[ 100 sel src1_alu(R[src2]_alu) ]...
--[ 011 sel src1_mem (R[src2_mem])]...




