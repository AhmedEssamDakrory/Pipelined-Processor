LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
entity Fetch_Hazard_Detection_Unit is
port(
typeOfInstr : in std_logic_vector(1 downto 0);
opCode:in std_logic_vector(2 downto 0);
dst_branch:in std_logic_vector(2 downto 0);
dst_dec:in std_logic_vector(2 downto 0);
src1_dec:in std_logic_vector(2 downto 0);
swap_dec:in std_logic;
wb_dec:in std_logic;
dst_alu:in std_logic_vector(2 downto 0);
src1_alu: in std_logic_vector(2 downto 0);
swap_alu: in std_logic;
wb_alu:in std_logic;
dst_mem: in std_logic_vector(2 downto 0);
load_sig_mem:in std_logic;
flush:out std_logic
);
end Fetch_Hazard_Detection_Unit;

architecture fetch_hazard_arch of Fetch_Hazard_Detection_Unit is
begin

flush <= '0' when (typeOfInstr /= "11" and ( opCode /= "001"  or opCode /= "000")) else 
		 '1' when ( (dst_branch = dst_dec and wb_dec = '1') or 
				  (dst_branch = src1_dec and swap_dec = '1') or 
				  (dst_branch = dst_alu and wb_alu = '1') or 
				  (dst_branch = src1_alu and swap_alu = '1') or
				  (dst_branch = dst_mem and load_sig_mem = '1')) else
		 '0';

end fetch_hazard_arch;
