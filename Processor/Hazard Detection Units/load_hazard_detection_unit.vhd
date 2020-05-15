LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
entity Load_Hazard_Detection_Unit is
port(
src1_dec:in std_logic_vector(2 downto 0);
src2_dec:in std_logic_vector(2 downto 0);
dst_alu:in std_logic_vector(2 downto 0);
load_sig_alu:in std_logic;
flush_branch:in std_logic;
flush_int_ret:in std_logic;
stall:out std_logic
);
end Load_Hazard_Detection_Unit;

architecture load_hazard_arch of Load_Hazard_Detection_Unit is
begin
stall <= '0' when (flush_branch = '1' or flush_int_ret = '1') else
		 '1' when (load_sig_alu = '1' and (src1_dec = dst_alu or src2_dec = dst_alu)) else
		 '0';
end load_hazard_arch;