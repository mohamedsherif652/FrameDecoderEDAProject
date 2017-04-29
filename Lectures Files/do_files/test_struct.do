# progressively change components from behavioral to structural in addaccu_struct.vhd

# delete the lock file if exists
file delete -force work/_lock

vcom -reportprogress 300 -work work {addaccu_struct.vhd}

delete wave *
do simulate_beh_struct.do
