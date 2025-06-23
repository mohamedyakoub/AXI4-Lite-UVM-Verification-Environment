vlib work
vlog ../interface/AXI4_Interface.sv ../tb/Env/AXI4_Assertions.sv ../rtl/axil_ram.v ../tb/Env/AXI4_pkg.sv ../tb/Env/tb.sv +cover +fcover +define+IDEAL
vsim -voptargs=+acc work.tb -cover +UVM_TESTNAME=AXI4_concurrent_test  -sv_seed random +UVM_VERBOSITY=UVM_LOW -l ../docs/logs
coverage save tb.ucdb -onexit 
add wave -position insertpoint sim:/tb/AXI4_intf/*
run -all 
quit -sim
vcover report tb.ucdb -details -annotate -all -output ../docs/coverage_rpt.txt
