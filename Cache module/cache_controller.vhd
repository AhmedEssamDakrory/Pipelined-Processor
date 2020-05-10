library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity cache_controller is
  
port(
  clk,rst												: in		std_logic;
  address_data, address_inst  							: in 		std_logic_vector(10 downto 0);
  write_data, write_inst								: in		std_logic ;
  read_data, read_inst									: in		std_logic ;
  stall_mem, stall_inst									: out 		std_logic;
  data_in_mem_stage										: in 		std_logic_vector(31 downto 0);
  data_in_inst_Stage									: in 		std_logic_vector(15 downto 0);
  data_out_mem_stage									: out 		std_logic_vector(31 downto 0);
  data_out_inst_stage									: out 		std_logic_vector(15 downto 0)
  );
end cache_controller;

architecture fsm of cache_controller is

	component cache IS
	generic (N : Integer := 32);
	port (
		clock   			: in  std_logic;
		we      			: in  std_logic;
		mem_procsseor		: in  std_logic;	-- memory = 0 / processor = 1
		index 				: in  std_logic_vector(4 downto 0);
		offset				: in  std_logic_vector(2 downto 0);
		datain_processor  	: in  std_logic_vector(N-1 downto 0);
		dataout_prcosseor 	: out std_logic_vector(N-1 downto 0);
		datain_mem			: in  std_logic_vector(127 downto 0);
		dataout_mem			: out std_logic_vector(127 downto 0)
	);
	end component ;
	
	component sync_ram IS
	port (
		clk		: in  std_logic;
		we      : in  std_logic;	-- write = 1 , read = 0
		enable	: in  std_logic;
		ready 	: out std_logic;
		address : in  std_logic_vector(11 downto 0);
		datain  : in  std_logic_vector(127 downto 0);
		dataout : out std_logic_vector(127 downto 0)
	);
	end component;

	type cache_control is array (0 to 31) of std_logic_vector(4 Downto 0);
	type state_type is (IDLE , WRITE_TO_MEM , READ_FROM_MEM );

	signal data_control 																: cache_control	:= ((others=> (others=>'0'))); -- valid  dirty  tag
	signal inst_control 																: cache_control := ((others=> (others=>'0')));
	signal current_state_data , next_state_data, current_state_inst, next_state_inst 	: state_type := IDLE ;
	signal mem_procsseor_data, mem_procsseor_inst										: std_logic;
	signal data_out_mem																	: std_logic_vector(127 downto 0);
	signal data_out_cache_data															: std_logic_vector(31 downto 0);
	signal data_in_cache_data															: std_logic_vector(31 downto 0);
	signal data_in_cache_inst															: std_logic_vector(15 downto 0);
	signal data_out_cache_inst															: std_logic_vector(15 downto 0);
	signal data_in_cache_mem_data, data_in_cache_mem_inst								: std_logic_vector(127 downto 0);
	signal data_out_cache_mem_data, data_out_cache_mem_inst								: std_logic_vector(127 downto 0);
	signal data_in_mem, inst_in_mem, in_mem 											: std_logic_vector(127 downto 0);
	signal out_address, out_address_data, out_address_inst								: std_logic_vector(11 downto 0);
	signal we_ram, we_ram_data, we_ram_inst, we_cache_data, we_cache_inst				: std_logic;
	signal enable_ram, enable_ram_data, enable_ram_inst									: std_logic;	
	signal ready																		: std_logic;

begin	
	
	
	data_cache: cache generic map(32) port map(clk, we_cache_data, mem_procsseor_data, address_data(7 downto 3), address_data(2 downto 0), data_out_cache_data, data_in_cache_data, data_out_cache_mem_data, data_in_cache_mem_data );
	inst_cache: cache generic map(16) port map(clk, we_cache_inst, mem_procsseor_inst, address_inst(7 downto 3), address_inst(2 downto 0), data_out_cache_inst, data_in_cache_inst, data_out_cache_mem_inst, data_in_cache_mem_inst );
	memory	  : sync_ram	port map(clk, we_ram, enable_ram, ready, out_address, in_mem, data_out_mem);
	

	
	-- Synchronous process next state  
	process(clk , rst)begin
		if( rst = '1' ) then
			current_state_data <= IDLE;
			current_state_inst <= IDLE;
		elsif(rising_edge(clk)) then
			current_state_data <= next_state_data;
			current_state_inst <= next_state_inst;
		end if;
	end process;
	
	-- Select control signals to ram
	process(current_state_data, current_state_inst, we_ram_data, we_ram_inst, out_address_data, out_address_inst ,data_in_mem, inst_in_mem, enable_ram_data, enable_ram_inst)begin
		if( current_state_data = READ_FROM_MEM or current_state_data = WRITE_TO_MEM) then
			we_ram <= we_ram_data;
			out_address <= out_address_data;
			in_mem <= data_in_mem;
			enable_ram <= enable_ram_data;
		elsif ( current_state_inst = READ_FROM_MEM or current_state_inst = WRITE_TO_MEM) then
			we_ram <= we_ram_inst;
			out_address <= out_address_inst;
			in_mem <= inst_in_mem;
			enable_ram <= enable_ram_inst;
		end if;
	end process;



-- Combinational circuit to estimate next state for data controller ----	
	process(rst, write_data , address_data , read_data ,data_in_cache_data, current_state_data, ready, data_in_mem_stage, data_in_cache_mem_data, data_out_mem) 
	variable tag_data, offset_data	:	std_logic_vector(2 downto 0);
	variable index_data				:	std_logic_vector(4 downto 0);
	begin
		if rst = '0' then		-- if processor is working
			tag_data := address_data(10 downto 8);
			index_data := address_data(7 downto 3);			-- parse index and offset and tag
			offset_data := address_data(2 downto 0);
			if( current_state_data = IDLE) then
				if(write_data = '1')then
					if( data_control(to_integer(unsigned(index_data)))(2 downto 0)  =  tag_data    
														and  data_control(to_integer(unsigned(index_data)))(4) = '1')then	-- my tag and data is valid
						stall_mem <= '0';
						we_cache_data <= '1';
						mem_procsseor_data <= '1';
						data_out_cache_data	<= data_in_mem_stage;
						data_control(to_integer(unsigned(index_data)))(3) <= '1';
					else 		
						stall_mem <= '1';
						we_cache_data <= '0';
						if data_control(to_integer(unsigned(index_data)))(3) = '1' then	-- current data is dirty
							next_state_data <= WRITE_TO_MEM; 
						else 
							next_state_data <= READ_FROM_MEM;
						end if;
					end if;
				elsif( read_data = '1')then
					if( data_control(to_integer(unsigned(index_data)))(2 downto 0)  =  tag_data    
														and  data_control(to_integer(unsigned(index_data)))(4) = '1')then	-- my tag and data is valid
						stall_mem <= '0';
						we_cache_data <= '0';
						mem_procsseor_data <= '1';
						data_out_mem_stage	<= data_in_cache_data;
						next_state_data <= IDLE;
					else 		
						stall_mem <= '1';
						if data_control(to_integer(unsigned(index_data)))(3) = '1' then	-- current data is dirty
							next_state_data <= WRITE_TO_MEM; 
						else 
							next_state_data <= READ_FROM_MEM;
						end if;
					end if;	
				end if;
			elsif current_state_data =  WRITE_TO_MEM then
				stall_mem <= '1';
				if ready = '1' then
					enable_ram_data <= '0' ;
					next_state_data <= READ_FROM_MEM;
				else 
					we_ram_data <= '1';
					enable_ram_data <= '1' ;
					mem_procsseor_data <= '0';
					out_address_data <= '1' & data_control(to_integer(unsigned(index_data) ))(2 downto 0) & index_data & "000" ;			
					data_in_mem <= data_in_cache_mem_data; 
				end if;
			elsif current_state_data = READ_FROM_MEM then
				stall_mem <= '1';
				if ready = '1' then
					enable_ram_data <= '0' ;
					mem_procsseor_data <= '0';
					data_control(to_integer(unsigned(index_data))) <= "10" & tag_data; -- not dirty any more & block is valid
					we_cache_data <= '1';
					data_out_cache_mem_data <= data_out_mem;
					next_state_data <= IDLE;
				else 
					we_ram_data <= '0';
					enable_ram_data <= '1' ;
					out_address_data <= '1' & address_data(10 downto 3) & "000" ;  
				end if;
			end if;
		end if;
	end process;
	
	
	
-- Combinational circuit to estimate next state for instruction controller ----	
	process(rst, address_inst, write_inst, data_in_inst_Stage, next_state_data, read_inst, current_state_inst, ready, data_in_cache_inst, data_in_cache_mem_inst, data_out_mem)
	variable tag_inst, offset_inst	:	std_logic_vector(2 downto 0);
	variable index_inst				:	std_logic_vector(4 downto 0);
	begin
		if rst = '0' then
			tag_inst := address_inst(10 downto 8);
			index_inst := address_inst(7 downto 3);
			offset_inst := address_inst(2 downto 0);
			if( current_state_inst = IDLE ) then
				if(write_inst = '1')then
					if( inst_control(to_integer(unsigned(index_inst)))(2 downto 0)  =  tag_inst   
														and  inst_control(to_integer(unsigned(index_inst)))(4) = '1')then	-- my tag and data is valid
						we_cache_inst <= '1';
						mem_procsseor_inst <= '1';
						data_out_cache_inst	<= data_in_inst_Stage;
						inst_control(to_integer(unsigned(index_inst)))(3) <= '1';
					else 		
						if( next_state_data = IDLE) then		-- data controller not using memory
							stall_inst <= '1';
							we_cache_inst <= '0';
							if inst_control(to_integer(unsigned(index_inst)))(3) = '1' then	-- current data is dirty
								next_state_inst <= WRITE_TO_MEM; 
							else 
								next_state_inst <= READ_FROM_MEM;
							end if;
						end if;
					end if;
				elsif(read_inst = '1')then
					if( inst_control(to_integer(unsigned(index_inst)))(2 downto 0)  =  tag_inst   
														and  inst_control(to_integer(unsigned(index_inst)))(4) = '1')then	-- my tag and data is valid
						we_cache_inst <= '0';
						mem_procsseor_inst <= '1';
						data_out_inst_stage	<= data_in_cache_inst;
						stall_inst <= '0';
					else 		
						if(next_state_data = IDLE) then
							stall_inst <= '1';
							if inst_control(to_integer(unsigned(index_inst)))(3) = '1' then	-- current data is dirty
								next_state_inst <= WRITE_TO_MEM; 
							else 
								next_state_inst <= READ_FROM_MEM;
							end if;
						end if;
					end if;	
				end if;
			elsif current_state_inst = WRITE_TO_MEM then
				stall_inst <= '1';
				if ready = '1' then
					enable_ram_inst <= '0' ;
					next_state_inst <= READ_FROM_MEM;
				else 
					if(next_state_data /= IDLE)then
						next_state_inst <= IDLE;
					end if;
					we_ram_inst <= '1';
					enable_ram_inst <= '1' ;
					mem_procsseor_inst <= '0';
					out_address_inst <= '0' & inst_control(to_integer(unsigned(index_inst)))(2 downto 0) & index_inst & "000" ; 
					inst_in_mem <= data_in_cache_mem_inst; 
				end if;
			elsif current_state_inst = READ_FROM_MEM then
				stall_inst <= '1';
				if ready = '1' then
					enable_ram_inst <= '0' ;
					mem_procsseor_inst <= '0';
					inst_control(to_integer(unsigned(index_inst))) <= "10" & tag_inst; -- not dirty any more & block is valid
					we_cache_inst <= '1';
					data_out_cache_mem_inst <= data_out_mem;
					next_state_inst <= IDLE;
				else
					if(next_state_data /= IDLE)then
						next_state_inst <= IDLE;
					end if;
					we_ram_inst <= '0';
					enable_ram_inst <= '1' ;
					out_address_inst <= '0' & address_data(10 downto 3) & "000" ;  
				end if;
			end if;
		end if;
	end process;
	
end fsm;


