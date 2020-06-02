library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity Main is
port(
    clk,rst,int : in std_logic;
    port_in	    : IN STD_LOGIC_VECTOR(31 downto 0);
	port_out    : out STD_LOGIC_VECTOR(31 downto 0)
);
end;

architecture MainArchitecture of Main is

    signal load_hazard_stall,fetch_hazard_flush,int_ret_flush,cache_stall_mem,cache_stall_fetch,taken_sel,wrong_pred_sel,write_back_sel :std_logic;
    signal Rdest_sel 	:	std_logic_vector(2 downto 0);
    Signal pc			: 	std_logic_vector(31 downto 0);

    --Memory buffer signals
    Signal PcWrBack_out,WbSig_out,MemToRegSig_out,OutPortSig_out,SwapSig_out    :std_logic;
    Signal DstAddress_out ,Src1Address_out                                      : std_logic_vector (2 downto 0);
    Signal AluResult_out,DataFromMem_out,Rsrc2_out                              : std_logic_vector (31 downto 0);

    Signal flush_mem :STD_LOGIC;



    --Alu Buffer Signals
    Signal PcWrBack_out_alu,Read_Sig_out_alu,Write_Sig_out_alu,WbSig_out_alu,MemToRegSig_out_alu,OutPortSig_out_alu,SwapSig_out_alu,flagsOrSrc_out_alu: std_logic;
    Signal Src1Address_out_alu,DstAddress_out_alu,flags_out_alu: std_logic_vector (2 downto 0);
    Signal AluResult_out_alu,Rsrc2_out_alu: std_logic_vector (31 downto 0);

    Signal alu_stall :STD_LOGIC;

    --Memory stage Signals
    Signal to_mem,data	:	std_logic_vector(31 downto 0);

    --Cache Controller Signals
    Signal data_out_mem_stage  : std_logic_vector(31 downto 0);
    Signal data_out_inst_stage : std_logic_vector(15 downto 0);

    --Main Signals
    signal Nand_output,Disable_extend : std_logic;

    --Fetch Buffer Signal
    Signal load_fetch_buffer,flush_fetch_buffer,flush_wrong_prediction,disableForImmediate_out,takenSigForBranch_out,rst_fetch_buffer :std_logic;
    Signal instr_out: STD_LOGIC_VECTOR(15 DOWNTO 0);
    Signal pc_out: STD_LOGIC_VECTOR(31 DOWNTO 0);

    --Decode stage Siganls
    Signal data1,data2,Rdst : STD_LOGIC_VECTOR(31 downto 0);		
    Signal sub,ea_immediate	,mem_read,mem_write,push_pop,jz,jmp,flags,flags_write_back,pc_inc,pc_write_back,src1,src2,select_in,		
           swap,mem_to_reg,write_back,out_port,enable,int_out_decode : std_logic;

    -- Decode Buffer Signal
    Signal PcWrBack_out_decode,Read_Sig_out_decode,Write_Sig_out_decode,WbSig_out_decode,MemToRegSig_out_decode,OutPortSig_out_decode,
    SwapSig_out_decode,ExtendSig_out_decode,EAOrImmSig_out_decode,JzSig_out_decode,TakenSigForBranch_out_decode,ALU_WrFlagSig_out_decode,
    unCondSig_out_decode,flagsOrSrc_out_decode,int_out_decode_buffer  : std_logic;

	  signal pc_exec_out_decode                 : std_logic_vector(9 downto 0);
    Signal typeOfInstr_out_decode             : std_logic_vector (1 downto 0);
    Signal Src1Address_out_decode, Src2Address_out_decode,DstAddress_out_decode,opcode_out_decode : std_logic_vector (2 downto 0);
    Signal EA_4_bits_out_decode               : std_logic_vector (3 downto 0);
    Signal data1_out_decode,data2_out_decode  : std_logic_vector (31 downto 0);	

    Signal decode_stall,decode_flush :std_logic;
    Signal EA_Concatination_signal :  std_logic_vector(3 downto 0);

    -- Execution Stage Signals
    Signal Operation               :std_logic_vector(4 downto 0);
    Signal ImmConcatenate          :std_logic_vector(31 downto 0);
    Signal FlagOutput              :std_logic_vector(3 downto 0);             
    Signal Result,BrnchTakenOutput, Data2_out_ex_stage :std_logic_vector(31 downto 0);
	signal prediction_out : std_logic;

    -- Alu forward Unit
    Signal src1_sel_forward_alu,src2_sel_forward_alu :std_logic_vector(2 downto 0);

    -- Signals
    Signal wb_mux_output           :std_logic_vector(31 downto 0);
    Signal concatenate_mux_signal_input,extend_mux_signal,sign_imm  :std_logic_vector(4 downto 0);
    Signal concatenate_mux_signal_output  :std_logic_vector(20 downto 0);
    Signal Last_Mux_Sel : std_logic;
    
    -- Branch Prediction Signal
    Signal branch_prediction_output, taken_in_branch_prediction :std_logic;
    


begin
    --Cache Controller
    Cache_Controller :entity work.cache_controller(fsm) port map(clk,rst, AluResult_out_alu(10 downto 0) ,pc(10 downto 0),Write_Sig_out_alu,'0',
    Read_Sig_out_alu,'1',cache_stall_mem,cache_stall_fetch,to_mem,(others=>'0'),data_out_mem_stage,data_out_inst_stage);
    --Fetch Stage
    Fetch_Stage :entity work.fetch_stage(structural) port map(clk,rst,int,load_hazard_stall,fetch_hazard_flush,int_ret_flush,cache_stall_mem,cache_stall_fetch
    ,'0',wrong_pred_sel,PcWrBack_out,Rdest_sel,data_out_mem_stage,Result,Rdst,BrnchTakenOutput,DataFromMem_out,data2_out_decode,Rsrc2_out_alu,data_out_inst_stage,pc);
    --Disable Signal
    Nand_output<= data_out_inst_stage(1) and (not(Disable_extend));
    flipflop :entity work.FlipFlop(arch) port map('1',rst,clk,Nand_output,Disable_extend);
    --Fetch buffer----
    rst_fetch_buffer<=(rst or flush_fetch_buffer);
    Fetch_Buffer :entity work.Fetch_Buffer(arch_fetch_buffer) port map(clk,load_fetch_buffer,rst_fetch_buffer,data_out_inst_stage,pc,Disable_extend,
    '0',instr_out,pc_out,disableForImmediate_out,takenSigForBranch_out);
    process(cache_stall_mem,int_ret_flush,load_hazard_stall,cache_stall_fetch,fetch_hazard_flush,wrong_pred_sel)
    begin
            --Flush  and stall signals
        if cache_stall_mem = '1'  or cache_stall_fetch = '1' then
            load_fetch_buffer<='0';
            flush_fetch_buffer<='0';
        elsif int_ret_flush ='1' or wrong_pred_sel = '1' then
            load_fetch_buffer<='1';
            flush_fetch_buffer<='1';
        elsif load_hazard_stall='1'  then
            load_fetch_buffer<='0';
            flush_fetch_buffer<='0';
        elsif fetch_hazard_flush='1' then
            load_fetch_buffer<='1';
            flush_fetch_buffer<='1';
        else
            load_fetch_buffer<='1';
            flush_fetch_buffer<='0';
        end if;
    end process;

    --Branch Prediction
    --Branch_Prediction_Unit :entity work.BranchPredictionBuffer(ArchOfBranchPredictionBuffer) port map('0',data_out_inst_stage(15 downto 11),
    --pc(9 downto 0), taken_in_branch_prediction,'1',rst,branch_prediction_output);
    --Decode Stage
    Decode_Unit :entity work.DecodeStage(arch) port map(clk,rst,instr_out(15 downto 14),instr_out(13 downto 11),int,load_fetch_buffer, OutPortSig_out,disableForImmediate_out,
    instr_out(7 downto 5),instr_out(4 downto 2),DstAddress_out,Src1Address_out,data_out_inst_stage(10 downto 8),WbSig_out,SwapSig_out,wb_mux_output,Rsrc2_out,
    pc,port_in,data1,data2,Rdst,port_out,sub,ea_immediate,mem_read,mem_write,push_pop,jz,jmp,flags,flags_write_back,pc_inc,pc_write_back,int_ret_flush,src1,src2,select_in,	
    swap,mem_to_reg,write_back,out_port,enable, int_out_decode);

    --Decoding buffer
    EA_Concatination_signal<=instr_out(7 downto 5)&instr_out(0);
    Decoding_Buffer_label:entity work.Decoding_Buffer(arch_Decoding_Buffer) port map(clk,decode_stall,decode_flush,int_out_decode, pc_out(9 downto 0),pc_write_back,mem_read,mem_write,write_back,mem_to_reg,out_port,
    swap,instr_out(1),ea_immediate,jz,takenSigForBranch_out,flags_write_back,jmp,flags,instr_out(15 downto 14),instr_out(13 downto 11),instr_out(7 downto 5),instr_out(4 downto 2),
    instr_out(10 downto 8),EA_Concatination_signal,data1,data2,PcWrBack_out_decode,Read_Sig_out_decode,Write_Sig_out_decode,WbSig_out_decode,MemToRegSig_out_decode,OutPortSig_out_decode,
    SwapSig_out_decode,ExtendSig_out_decode,EAOrImmSig_out_decode,JzSig_out_decode,TakenSigForBranch_out_decode,ALU_WrFlagSig_out_decode,
    unCondSig_out_decode,flagsOrSrc_out_decode,typeOfInstr_out_decode,opcode_out_decode,Src1Address_out_decode,Src2Address_out_decode,DstAddress_out_decode,
    EA_4_bits_out_decode,data1_out_decode,data2_out_decode, pc_exec_out_decode, int_out_decode_buffer);

    process(cache_stall_mem,wrong_pred_sel,disableForImmediate_out,cache_stall_fetch,load_hazard_stall)
    begin
            --Flush  and stall signals
        if cache_stall_mem='1'  or cache_stall_fetch = '1' then
            decode_stall<='0';
            decode_flush<='0';
        elsif wrong_pred_sel='1' or load_hazard_stall = '1' then
            decode_stall<='1';
            decode_flush<='1';
        elsif disableForImmediate_out='1' then
            decode_stall<='1';
            decode_flush<='1';
        else
            decode_stall<='1';
            decode_flush<='0';
        end if;
    end process;

	--int_ff 	: entity work.FlipFlop port map('1', rst, clk, int_ret_flush, int_out_decode);
    --Execution Stage
    Operation <=	typeOfInstr_out_decode & opcode_out_decode;
    Execution_Stage :entity work.Execution(ExecutionArch) port map(int_out_decode_buffer,data1_out_decode,data2_out_decode,AluResult_out_alu, wb_mux_output,ImmConcatenate,
    data2_out_decode,Rsrc2_out_alu,Rsrc2_out,Operation,DataFromMem_out(3 downto 0),src1_sel_forward_alu,src2_sel_forward_alu,clk, decode_flush,ExtendSig_out_decode,
    ALU_WrFlagSig_out_decode,TakenSigForBranch_out_decode,FlagOutput,prediction_out,Result,BrnchTakenOutput,Data2_out_ex_stage);

    --Wrong prediction signals 
    flush_wrong_prediction <= (FlagOutput(0) xnor (not TakenSigForBranch_out_decode)) and JzSig_out_decode;
    wrong_pred_sel <= flush_wrong_prediction or unCondSig_out_decode;
	taken_in_branch_prediction <= TakenSigForBranch_out_decode when flush_wrong_prediction = '0' else
								  not TakenSigForBranch_out_decode;

    --Alu Buffer
    Alu_Buffer_label:entity work.ALU_Buffer(arch_alu_buffer) port map(clk,alu_stall,rst,PcWrBack_out_decode,Read_Sig_out_decode,Write_Sig_out_decode
    ,WbSig_out_decode,MemToRegSig_out_decode,OutPortSig_out_decode,SwapSig_out_decode,flagsOrSrc_out_decode,DstAddress_out_decode,Src1Address_out_decode,FlagOutput(2 downto 0),
    Result,Data2_out_ex_stage,PcWrBack_out_alu,Read_Sig_out_alu,Write_Sig_out_alu,WbSig_out_alu,MemToRegSig_out_alu,OutPortSig_out_alu,SwapSig_out_alu,
    flagsOrSrc_out_alu,DstAddress_out_alu, Src1Address_out_alu,flags_out_alu,AluResult_out_alu,Rsrc2_out_alu);

   -- process(cache_stall_mem, cache_stall_fetch)
    --begin
      --      --Flush  and stall signals
        --if cache_stall_mem='1'  or cache_stall_fetch ='1'  then
          --  flush_mem<='1';
        --else
          --  flush_mem<='0';
        --end if;
    --end process;
 
    --alu Forward Unit
    alu_Forward_Unit :entity work.ALU_Forwarding_Unit(arch_alu_forwarding_unit) port map(Operation,Src1Address_out_decode, Src2Address_out_decode,
    Src1Address_out,DstAddress_out,Src1Address_out_alu,DstAddress_out_alu,WbSig_out,WbSig_out_alu,SwapSig_out,SwapSig_out_alu,src1_sel_forward_alu,
    src2_sel_forward_alu);

    -- Fetch forward unit
    fetch_forward_unit:entity work.Fetch_Forwarding_Unit(arch_fetch_forwarding_unit) port map(data_out_inst_stage(13 downto 11),Src1Address_out_alu,
    DstAddress_out_alu,Src1Address_out_decode,DstAddress_out_decode,WbSig_out_alu,WbSig_out_decode,SwapSig_out_alu,SwapSig_out_decode,Rdest_sel);

    --Memory stage
    Memory_Stage :entity work.memory_stage(structural) port map(flagsOrSrc_out_alu,SwapSig_out_alu,to_mem,data,Rsrc2_out_alu,AluResult_out_alu,data_out_mem_stage,
    FlagOutput(2 downto 0));

    --Memory Buffer
    Memory_Buffer_label:entity work.Mem_Buffer(arch_mem_buffer) port map(clk, alu_stall,rst,PcWrBack_out_alu,WbSig_out_alu,MemToRegSig_out_alu,
    OutPortSig_out_alu,SwapSig_out_alu,DstAddress_out_alu,Src1Address_out_alu,AluResult_out_alu,data,Rsrc2_out_alu,PcWrBack_out,WbSig_out,MemToRegSig_out,OutPortSig_out,SwapSig_out,
    DstAddress_out ,Src1Address_out,AluResult_out,DataFromMem_out,Rsrc2_out);    
    
    process(cache_stall_mem, cache_stall_fetch)
    begin
            --Flush  and stall signals
        if cache_stall_mem='1'  or cache_stall_fetch ='1'  then
            alu_stall<='0';
        else
            alu_stall<='1';
        end if;
    end process;

    --Write back stage
	Last_Mux_Sel <= MemToRegSig_out or SwapSig_out;
    Mux2_1 :entity work.Mux2(arch_mux2) generic map(N=>32) port map(AluResult_out,DataFromMem_out,Last_Mux_Sel,wb_mux_output);

    --Concatenate mux
    concatenate_mux_signal_input <= '0'&EA_4_bits_out_decode;
    sign_imm <=instr_out(15)&instr_out(15)&instr_out(15)&instr_out(15)&instr_out(15);
    Mux2_2 :entity work.Mux2(arch_mux2) generic map(N=>5) port map(sign_imm,concatenate_mux_signal_input,EAOrImmSig_out_decode,extend_mux_signal);
    concatenate_mux_signal_output <= extend_mux_signal&instr_out;

    ImmConcatenate<= "00000000000"&concatenate_mux_signal_output when concatenate_mux_signal_output(20)='0' else
                     "11111111111"&concatenate_mux_signal_output;   

    -- Load hazard detection unit
    Load_hazard_detection_unit_label :entity work.Load_Hazard_Detection_Unit(load_hazard_arch) port map(instr_out(7 downto 5),instr_out(4 downto 2),
    DstAddress_out_decode,MemToRegSig_out_decode,flush_wrong_prediction,int_ret_flush,load_hazard_stall);

    --Fetch hazard detection
    fetch_hazard_detection_unit_label :entity work.Fetch_Hazard_Detection_Unit(fetch_hazard_arch) port map(data_out_inst_stage(15 downto 14),data_out_inst_stage(13 downto 11),
	data_out_inst_stage(10 downto 8), instr_out(10 downto 8),instr_out(7 downto 5),swap,write_back,DstAddress_out_decode,Src1Address_out_decode,SwapSig_out_decode,
	WbSig_out_decode,DstAddress_out_alu, MemToRegSig_out_alu,fetch_hazard_flush);

end MainArchitecture;