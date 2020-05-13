vsim -gui work.cache_controller 
add wave -position insertpoint sim:/cache_controller/*

force -freeze sim:/cache_controller/clk 0 0
force -freeze sim:/cache_controller/rst 1 0
run

#read data miss

force -freeze sim:/cache_controller/clk 0 0
force -freeze sim:/cache_controller/rst 0 0
force -freeze sim:/cache_controller/address_data 00000000000 0
force -freeze sim:/cache_controller/address_inst 00000000000 0
force -freeze sim:/cache_controller/data_in_mem_stage  10101010101010101010101010101010 0	
force -freeze sim:/cache_controller/data_in_inst_stage 0101010101010101 0
force -freeze sim:/cache_controller/read_inst 1 0
force -freeze sim:/cache_controller/read_data 1 0
run

force -freeze sim:/cache_controller/clk 1 0
force -freeze sim:/cache_controller/rst 0 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

# read data hit
force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/read_data 0 0
force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

# Write data hit

force -freeze sim:/cache_controller/read_data 0 0
force -freeze sim:/cache_controller/write_data 1 0
force -freeze sim:/cache_controller/write_inst 1 0
force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/address_data 10000000000 0
force -freeze sim:/cache_controller/address_inst 10000000000 0
force -freeze sim:/cache_controller/clk 0 0
run

# write back 


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run

force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run


force -freeze sim:/cache_controller/clk 1 0
run

force -freeze sim:/cache_controller/clk 0 0
run