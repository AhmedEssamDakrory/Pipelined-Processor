library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;
entity ALU is
    generic (N : Integer := 32);
    port(
		clk				:	IN STD_LOGIC;
        Operation		:  	IN std_logic_vector(4 downto 0);
        FlagsOutput		: 	OUT std_logic_vector(3 downto 0);
        A,B 			:	IN std_logic_vector(N-1 downto 0);
		int				: 	IN std_logic;
        Result			:	OUT std_logic_vector(N-1 downto 0)
    );
end ALU;
architecture ALU_arcitecture of ALU is
    signal ResultSignal:std_logic_vector(N downto 0);
	  signal flag : STD_LOGIC_vector(1 downto 0) := "00";

    function CheckZero (F: in std_logic_vector)
    return std_logic is
    variable Zero : std_logic := '0';
    begin
    for i in 0 to F'length-1 loop
      Zero := Zero or F(i);
    end loop;
    return Zero;
    end function CheckZero;
begin
    process(A,B,Operation,ResultSignal)
	begin
		if(int = '1') then
			ResultSignal <= '0' & A ; 
        elsif (flag(1) = '0' and flag(0) = '0' and Operation(4)='0' and Operation(3)='0' )then  -- One Operand
            case(Operation(2 downto 0)) is
                when "000" => -- Nop
                ResultSignal <= (others => '0');
                when "001" => --Not
                ResultSignal <= '0' & not A ;
                when "010" => --INC
                ResultSignal <= '0' & std_logic_vector(signed(A)+1);
                when "011" => --DEC
                ResultSignal <= '0' & std_logic_vector(signed(A)-1);
                when "101" => --IN & Nob A
                ResultSignal <= '0' & A ;
                when "100" => --Nop A
                ResultSignal <= '0' & A ;
                when others => ResultSignal <= (others => '0'); 
            end case;
        elsif ( flag(1) = '0' and flag(0) ='0' and Operation(4)='0' and Operation(3)='1') then  -- Two Operand
            case(Operation(2 downto 0)) is
                when "000" => -- Swap
                ResultSignal <= '0' & A ; 
                when "001" => -- A+B
                ResultSignal <= '0' & std_logic_vector(signed(A)+signed(B));
                when "010" => --A+B
                ResultSignal <= '0' & std_logic_vector(signed(A)+signed(B));
                when "011" => --Sub
                ResultSignal <= '0' & std_logic_vector(signed(A)-signed(B));
                when "100" => --And
                ResultSignal <= '0' & (A and B) ;
                when "101" => --Or
                ResultSignal <= '0' & (A or B );
                when "111" => --SHR
                ResultSignal <= '0' & std_logic_vector(unsigned(A) srl to_integer(unsigned(B)));
                when "110" => --SHL
                ResultSignal <= '0' & std_logic_vector(unsigned(A) sll to_integer(unsigned(B)));
                when others => ResultSignal <= (others => '0');
            end case;
         elsif ( flag(1) = '0' and flag(0) ='0' and Operation(4)='1' and Operation(3)='0') then  -- Memory
            case(Operation(2 downto 0)) is
				when "000" => ResultSignal <= '0' & A;
				when "001" => ResultSignal <= '0' & A;
                when others => ResultSignal <= '0' & B ;
            end case;
		else	-- Branch
			ResultSignal <= '0' & A;
        end if;    
		
		
        ---------Update Flags--------------------------
		if(not(Operation(4)='0' and Operation(3)='0' and Operation(2)='1' and Operation(1)='0' and Operation(0)='1' )) then
			FlagsOutput(0)<=(not CheckZero(ResultSignal(N-1 downto 0)));
			if(ResultSignal(N-1)='1')then
				FlagsOutput(1)<='1';
			else
				FlagsOutput(1)<='0';
			end if;
			FlagsOutput(2)<=ResultSignal(N);
		end if;
        
		
		Result<=ResultSignal(N-1 downto 0);   

	
	process(clk)
		begin
		if(rising_edge(clk) )then
			if Operation(2) = '1' and Operation(1) = '0' and Operation(0) = '0'then 
				flag <= "01";
			elsif flag(1) = '0' and flag(0) = '1' then
				flag <= "10";
			else
				flag <= "00";
			end if;
		end if;
	end process;
end ALU_arcitecture;
