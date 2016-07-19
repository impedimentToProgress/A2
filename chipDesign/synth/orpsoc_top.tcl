# OpenRISC Synthesis Script 
# Written by Mojtaba Ebrahimi 

source -verbose "../common/common.tcl"

set base_dir "../../verilog/or1200/" 
set top_level "orpsoc_top"

source -verbose "./orpsoc_top_read_verilog.tcl"

link 

set clk_period 3
set clk_uncertainty 0.3
set clk_transition 0.1
set clk_latency 0.05

set clk_port "sys_clk_in_p"
set clk_name "CLK"
create_clock -name $clk_name -period $clk_period $clk_port

set typical_input_delay 0.00
set typical_output_delay 0.200
set typical_wire_load 0.2

#set_operating_conditions tt28_1.00V_25C -library C32_SC_12_CORE_LSL
set_wire_load_model -name ZeroWireload
#set_wire_load_mode enclosed

set_clock_latency $clk_latency [all_clocks]
set_clock_transition $clk_transition [all_clocks]
set_clock_uncertainty -setup 0.1 [all_clocks]
set_clock_uncertainty -hold $clk_uncertainty [all_clocks]
set_ideal_network [get_ports sys_clk_in_p]

set_max_transition 0.100 $top_level
set_max_fanout 20 $top_level

set_driving_cell -lib_cell BUFX1BA10TR [all_inputs]
set_driving_cell -lib_cell BUFX4BA10TR [find port $clk_port]

#set_input_delay $typical_input_delay  -clock $clk_name [all_inputs]
#remove_input_delay -clock $clk_name [find port $clk_port]
set_output_delay $typical_output_delay -clock $clk_name [all_outputs] 

set_load $typical_wire_load [all_outputs] 

set_fix_hold [all_clocks] 

report_ideal_network


#ensure no net connect to multiple ports
set_fix_multiple_port_nets -all -buffer_constants
check_design

uniquify -dont_skip_empty_designs 
#ungroup -all -flatten

compile -map_effort high
#compile_ultra
compile -inc -only_design_rule

source -verbose "../common/namingrules.tcl"

# Generate structural verilog netlist
write -hierarchy -format verilog -output "${top_level}.nl.v"

# Generate Standard Delay Format (SDF) file
write_sdf -context verilog "${top_level}.dc.sdf"

# Write SDC
write_sdc -nosplit -version 1.3 "${top_level}.sdc"

# Write DDC
write_file -format ddc -hierarchy -output "${top_level}.ddc"

##### Create report (timing, cells, etc...)
set rpt_file "${top_level}.dc.rpt"
set maxpaths 20
check_design > $rpt_file
report_area  >> ${rpt_file}
report_resources -hierarchy > ${rpt_file}
#report_power -hier -analysis_effort medium >> ${rpt_file}
report_design >> ${rpt_file}
report_cell >> ${rpt_file}
report_port -verbose >> ${rpt_file}
#report_compile_options >> ${rpt_file}
report_constraint -all_violators -verbose >> ${rpt_file}
report_timing -path full -delay max -max_paths $maxpaths -nworst 10 >> ${rpt_file}
report_timing -path full -delay min -max_paths $maxpaths -nworst 10 >> ${rpt_file}
report_timing_requirements >> ${rpt_file} 


report_timing  -from { or1200_top0/or1200_cpu/or1200_ctrl/ex_branch_op_reg_0_/Q } -to { or1200_top0/or1200_cpu/or1200_sprs/sr_reg_reg_0_/D } -nworst 20 -max_paths 20 -unique_pins >> paths.rpt
