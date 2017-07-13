######################################################
# Script for Cadence Genus synthesis      
# Timothy Trippel, 2017
# Use with syn-rtl -f rtl-script
######################################################

# Set the search paths to the libraries and the HDL files
# Remember that "." means your current directory. Add more directories
# after the . if you like. 
set_attribute hdl_search_path {../verilog/orpsoc/or1200/ ../verilog/orpsoc/arbiter ../verilog/orpsoc/ram_wb ../verilog/orpsoc/clkgen ../verilog/orpsoc/top  } 
set_attribute lib_search_path {/home/cadlib/Processes/IBM/STANDARD_CELLS/Virage/cp65npksdsta03/liberty/logic_synth}
set_attribute library [list "/home/cadlib/Processes/IBM/STANDARD_CELLS/Virage/cp65npksdsta03/liberty/logic_synth/cp65npksdst_ss0p80v125c.lib"]
# ../verilog/orpsoc/uart16550/

# Load HDL source files
set hdl_src_files [list "or1200_alu.v" \
"or1200_fpu_post_norm_div.v" \
"or1200_fpu_div.v" \
"or1200_fpu_pre_norm_div.v" \
"or1200_fpu_post_norm_mul.v" \
"or1200_fpu_mul.v" \
"or1200_fpu_pre_norm_mul.v" \
"or1200_fpu_post_norm_addsub.v" \
"or1200_fpu_addsub.v" \
"or1200_fpu_pre_norm_addsub.v" \
"or1200_fpu_arith.v" \
"or1200_fpu_post_norm_intfloat_conv.v" \
"or1200_fpu_intfloat_conv.v" \
"or1200_fpu_fcmp.v" \
"or1200_fpu.v" \
"or1200_mem2reg.v" \
"or1200_reg2mem.v" \
"or1200_dpram.v" \
"or1200_rfram_generic.v" \
"or1200_rf.v" \
"or1200_genpc.v" \
"or1200_if.v" \
"or1200_ctrl.v" \
"or1200_operandmuxes.v" \
"or1200_amultp2_32x32.v" \
"or1200_gmultp2_32x32.v" \
"or1200_mult_mac.v" \
"or1200_sprs.v" \
"or1200_lsu.v" \
"or1200_wbmux.v" \
"or1200_freeze.v" \
"or1200_except.v" \
"or1200_cfgr.v" \
"or1200_cpu.v" \
"or1200_spram.v" \
"or1200_ic_ram.v" \
"or1200_ic_tag.v" \
"or1200_ic_fsm.v" \
"or1200_ic_top.v" \
"or1200_dc_ram.v" \
"or1200_dc_tag.v" \
"or1200_dc_fsm.v" \
"or1200_dc_top.v" \
"or1200_immu_tlb.v" \
"or1200_immu_top.v" \
"or1200_dmmu_tlb.v" \
"or1200_dmmu_top.v" \
"or1200_iwb_biu.v" \
"or1200_wb_biu.v" \
"or1200_qmem_top.v" \
"or1200_sb_fifo.v" \
"or1200_sb.v" \
"or1200_du.v" \
"or1200_top.v"\
"or1200_tt.v" \
"or1200_pm.v" \
"or1200_pic.v" \
"arbiter_bytebus.v" \
"arbiter_dbus.v" \
"arbiter_ibus.v" \
"ram_wb.v" \
"ram_wb_b3.v" \
"clkgen.v" \
"orpsoc-defines.v" \
"synthesis-defines.v" \
"timescale.v" \
"orpsoc_top.v"];

# "raminfr.v" \
# "uart_defines.v" \
# "uart_top.v" \
# "uart_wb.v" \
# "uart_regs.v" \
# "uart_sync_flops.v" \
# "uart_transmitter.v" \
# "uart_receiver.v" \
# "uart_tfifo.v" \
# "uart_rfifo.v" \

set report_dir "synth_reports";# name of directory to place output files
set netlist_dir "../netlist"  ;# name of directory to place output files
set top_level "orpsoc_top"    ;# name of top level module

#set clk_period 20000; # 20 ns clock period = 50 MHz
set clk_period 10000; # 10 ns clock period = 100 MHz
set clk_uncertainty 0.3
set clk_transition 0.1
set clk_latency 0.05
set clk_port "sys_clk_in_p"
set clk_name "CLK"

# set typical_input_delay 0.00
set typical_output_delay 0.200
set typical_wire_load 0.2

set_attribute wireload_mode enclosed 
set_attribute hdl_error_on_blackbox true
set_attribute information_level 7 
set_attribute hdl_preserve_unused_registers true
set_attribute optimize_merge_flops false
set_attribute optimize_merge_latches false
set_attribute optimize_constant_0_flops false
set_attribute optimize_constant_1_flops false
set_attribute optimize_constant_latches false
set_attribute delete_unloaded_seqs false
set_attribute write_vlog_preserve_net_name true
set_attribute hdl_max_loop_limit 2570
set_attribute use_tiehilo_for_const unique
set_attribute auto_partition true
set_attribute remove_assigns true; # must be false if "remove_assigns_without_optimization" is used
set_attribute hdl_max_memory_address_range 4294967296

# Synthesis Effort
# set_attribute syn_generic_effort medium
# set_attribute syn_map_effort low
# set_attribute syn_opt_effort none

#*********************************************************
#*   below here shouldn't need to be changed...          *
#*********************************************************
# Analyze and Elaborate the HDL files
read_hdl ${hdl_src_files}
elaborate ${top_level}

# set_wire_load_model -name "enclosed"

# Create Clock
create_clock -name $clk_name -period $clk_period $clk_port
set_clock_uncertainty -setup 0.1 [all_clocks]
set_clock_uncertainty -hold $clk_uncertainty [all_clocks]
set_clock_latency $clk_latency [all_clocks]
set_clock_transition $clk_transition [all_clocks]
set_clock_uncertainty -setup 0.1 [all_clocks]
set_clock_uncertainty -hold $clk_uncertainty [all_clocks]

# Disable timing of clock??
set_ideal_network [get_ports $clk_port]

set_max_transition 0.100 $top_level
# set_max_fanout 20 $top_level
set_max_fanout 10 $top_level

set_driving_cell -lib_cell SEN_BUF_AS_1 [all_inputs]
set_driving_cell -lib_cell SEN_BUF_AS_4 [get_ports $clk_port]

set_output_delay $typical_output_delay -clock $clk_name [all_outputs] 

set_load $typical_wire_load [all_outputs] 

# report port [get_ports sys_clk_in_p]

set_remove_assign_options -dont_skip_unconstrained_paths -design ${top_level} 

# check that the design is OK so far
check_design

uniquify $top_level

# Synthesize the design to the target library
# syn_generic ${top_level}
# syn_map ${top_level}
synthesize -to_generic -eff low
synthesize -to_mapped -effort low  
# remove_assigns_without_optimization -dont_skip_unconstrained_paths -design ${top_level}

# Write out the structural Verilog and sdc files
write_hdl -mapped   > ${netlist_dir}/${top_level}.nl.v
write_sdc           > ${netlist_dir}/${top_level}.sdc

# Write out the reports
check_design > ${report_dir}/${top_level}_main.rpt
report area > ${report_dir}/${top_level}_area.rpt
report messages -error > ${report_dir}/${top_level}_errors.rpt
report design_rules ${top_level} > ${report_dir}/${top_level}_drc.rpt
report power ${top_level} > ${report_dir}/${top_level}_power.rpt
report timing -lint > ${report_dir}/${top_level}_timing.rpt
report gates ${top_level} > ${report_dir}/${top_level}_cell.rpt
# report port         > ${report_dir}/${top_level}_port.rpt

exit
