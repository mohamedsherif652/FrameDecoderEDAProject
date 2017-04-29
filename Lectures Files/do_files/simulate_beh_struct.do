vsim work.testbench_beh_struct

add wave -position insertpoint  \
sim:/testbench_beh_struct/sel \
sim:/testbench_beh_struct/clock \
sim:/testbench_beh_struct/a \
sim:/testbench_beh_struct/b \
sim:/testbench_beh_struct/s_beh \
sim:/testbench_beh_struct/s_struct \
sim:/testbench_beh_struct/dut_struct/reg_out \
sim:/testbench_beh_struct/dut_struct/mux_out 

run 640ns
