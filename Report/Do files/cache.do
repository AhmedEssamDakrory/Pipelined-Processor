vsim -gui work.main
add wave -position insertpoint sim:/main/*
add wave -position insertpoint sim:/main/Decode_Unit/*
add wave -position insertpoint sim:/main/Cache_Controller/*
add wave -position insertpoint sim:/main/Cache_Controller/*
add wave -position insertpoint sim:/main/Fetch_Stage/*
add wave -position insertpoint sim:/main/Fetch_Buffer/*
add wave -position insertpoint sim:/main/Decoding_Buffer_label/*
add wave -position insertpoint sim:/main/Decode_Unit/register_file/*
add wave -position insertpoint sim:/main/Alu_Buffer_label/*
add wave -position insertpoint sim:/main/Memory_Buffer_label/*
add wave -position insertpoint sim:/main/Execution_Stage/*
add wave -position insertpoint sim:/main/alu_Forward_Unit/*

force -freeze sim:/main/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/main/rst 1 0
force -freeze sim:/main/int 0 0
run
run
force -freeze sim:/main/rst 0 0
run

run
run
run
run
run
run
run
run
run
run
run
run
run

# cache test case
force -freeze sim:/main/port_in 16#118 0
run
force -freeze sim:/main/port_in 16#18 0
run
force -freeze sim:/main/port_in 16#2 0
run
force -freeze sim:/main/port_in 16#30 0
run


run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run

run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run

force -freeze sim:/main/port_in 16#38 0
run
force -freeze sim:/main/port_in 16#50 0
run
force -freeze sim:/main/port_in 16#0 0
for {set x 0} {$x<58} {incr x} {
    run
}
