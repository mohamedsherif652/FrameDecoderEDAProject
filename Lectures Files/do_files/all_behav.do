# All instances are Behavioral in addaccu_struct.vhd

# delete the lock file if exists
file delete -force work/_lock

# Structural addaccu, but all components are behavioral 
vcom -reportprogress 300 -work work {accu.vhd}
vcom -reportprogress 300 -work work {alu.vhd}
vcom -reportprogress 300 -work work {mux.vhd}
vcom -reportprogress 300 -work work {addaccu_struct.vhd}

# Behavioral addaccu
vcom -reportprogress 300 -work work {addaccu_beh.vhd}

# Testbench
vcom -reportprogress 300 -work work {addaccu_beh_struct_test.vhd}

# Comment if no wave window is opened
# delete wave *

# Simulation and waveform plotting
do simulate_beh_struct.do
