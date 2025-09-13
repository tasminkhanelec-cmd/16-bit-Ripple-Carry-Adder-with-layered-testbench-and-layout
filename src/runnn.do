vlog -sv testbench.sv
vsim -c -coverage work.testbench
run -all
coverage report -details -output rca.txt 
quit -sim
