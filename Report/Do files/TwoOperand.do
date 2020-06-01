vsim -gui work.main
add wave -position insertpoint sim:/main/*
add wave -position insertpoint sim:/main/Decode_Unit/*
add wave -position insertpoint sim:/main/Cache_Controller/*
add wave -position insertpoint sim:/main/Fetch_Stage/*
add wave -position insertpoint sim:/main/Fetch_Buffer/*
add wave -position insertpoint sim:/main/Decoding_Buffer_label/*
add wave -position insertpoint sim:/main/Decode_Unit/register_file/*
add wave -position insertpoint sim:/main/Alu_Buffer_label/*
add wave -position insertpoint sim:/main/Memory_Buffer_label/*
add wave -position insertpoint sim:/main/Execution_Stage/*
add wave -position insertpoint sim:/main/alu_Forward_Unit/*
add wave -position insertpoint sim:/main/Branch_Prediction_Unit/*

force -freeze sim:/main/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/main/rst 1 0
force -freeze sim:/main/int 0 0
run
run
force -freeze sim:/main/rst 0 0
run

for {set x 0} {$x<13} {incr x} {
    run
}

force -freeze sim:/main/port_in 16#5 0
run
force -freeze sim:/main/port_in 16#19 0
run
force -freeze sim:/main/port_in 16#FFFD 0
run
force -freeze sim:/main/port_in 16#F320 0
run

for {set x 0} {$x<30} {incr x} {
    run
}
