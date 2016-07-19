# common.tcl setup library files

set SYNOPSYS [get_unix_variable SYNOPSYS]
#set lib_root /afs/eecs.umich.edu/kits/ARM/TSMC_65lp/arm_2013q1/TS25LB021-FB-00000-r0p0-00rel0/arm/tsmc/cln65lp/sc9_base_hvt/r0p0
set lib_root /afs/eecs.umich.edu/kits/ARM/TSMC_65gp/arm_2010q1/rvt_sc-adv10-v21_2008q2v1/aci/sc-ad10/synopsys

set search_path [list "." "../../verilog/top" "../../sram" "../../rf" ${SYNOPSYS}/libraries/syn ${lib_root} /afs/eecs.umich.edu/kits/ARM/TSMC_65gp/arm_2010q1/tpdn65lpnv2_140b/digital/Front_End/timing_power_noise/NLDM/tpdn65lpnv2_140b ]

#set link_library "* scadv10_cln65gp_lvt_tt_1p0v_25c.db"
#set target_library "scadv10_cln65gp_lvt_tt_1p0v_25c.db "

set synthetic_library [list "dw_foundation.sldb"]

set link_library "* scadv10_cln65gp_rvt_tt_1p0v_25c.db tpdn65lpnv2tc.db sram_32Kx32_tt_1p0v_25c_syn.db rf_32x32_tt_1p0v_25c_syn.db"

set target_library "scadv10_cln65gp_rvt_tt_1p0v_25c.db tpdn65lpnv2tc.db"

#set hdlin_report_inferred_modules true




