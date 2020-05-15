vsim -gui work.sync_ram 
add wave -position insertpoint sim:/sync_ram/*

force -freeze sim:/sync_ram/clk 0 0
force -freeze sim:/sync_ram/enable 1 0
force -freeze sim:/sync_ram/we 0 0
force -freeze sim:/sync_ram/address 000000000000 0
run

force -freeze sim:/sync_ram/clk 1 0
run

force -freeze sim:/sync_ram/clk 0 0
run

force -freeze sim:/sync_ram/clk 1 0
run

force -freeze sim:/sync_ram/clk 0 0
run

force -freeze sim:/sync_ram/clk 1 0
run

force -freeze sim:/sync_ram/clk 0 0
run

force -freeze sim:/sync_ram/clk 1 0
run

force -freeze sim:/sync_ram/clk 0 0
force -freeze sim:/sync_ram/enable 1 0
force -freeze sim:/sync_ram/we 1 0
force -freeze sim:/sync_ram/address 000000000000 0
force -freeze sim:/sync_ram/datain 11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
run

force -freeze sim:/sync_ram/clk 1 0
run

force -freeze sim:/sync_ram/clk 0 0
run

force -freeze sim:/sync_ram/clk 1 0
run

force -freeze sim:/sync_ram/clk 0 0
run

force -freeze sim:/sync_ram/clk 1 0
run

force -freeze sim:/sync_ram/clk 0 0
run

force -freeze sim:/sync_ram/clk 1 0
run

force -freeze sim:/sync_ram/clk 0 0
run

force -freeze sim:/sync_ram/clk 1 0
run




