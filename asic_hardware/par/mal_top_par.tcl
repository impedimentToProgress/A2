###################################
# Author: Timothy Trippel
# Last Edited: August 2017
###################################
set global_config mal_top.globals
set output_dir    par_output
set par_root  	  /home/ttrippel/A2/asic_hardware/par
set map_file_path /home/cadlib/Processes/IBM/STANDARD_CELLS/ARM/12s0/ibm/soi12s0/sc12_base_v31_rvt/2009q1v2/lef/tech_nominal_25c_3_20_30_00_00_02_LB.map

###################################
# CONFIG
###################################
set top_level     	  MAL_TOP
set process       	  45;  # nm
set io_pad_width  	  130; # width of IO pad in microns
set top_routing_layer 10

# Die Dimensions
set block_width   540
set block_height  400

# Core Offsets
set left_offset   30
set right_offset  40
set top_offset    30
set bottom_offset 30

# Power Stripe Offsets and Spacing
set pstripe_spacing 50
set pstripe_start   [expr 0 + $left_offset + $pstripe_spacing]
set pstripe_stop    [expr $block_width - $io_pad_width - $right_offset + 1]

###################################
# Misc Functions
###################################

#proc get_multithread_lic { } {
  # getMultiCpuLicense 8
  # setMultiCpuUsage -acquireLicense 8
#}

# restore_from_saved ${par_root} ${top_level}
# proc restore_from_saved { par_root top_level } {
#     restoreDesign ${par_root}/${top_level}.route.enc.dat ${top_level}
#     redraw
#     fit
#     win
# }

proc connect_std_cells_to_power { } {
    globalNetConnect VDD -type tiehi -inst * -verbose
    globalNetConnect VSS -type tielo -inst * -verbose
    globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
    globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
    applyGlobalNets
}

###################################
# Init
###################################
# Load Design
source ./${global_config}
init_design -setup {setup_view} -hold {hold_view}
set_interactive_constraint_modes [all_constraint_modes]

###################################
# Floorplan
###################################

# Initial floorplan
setIoFlowFlag 0
floorPlan -site SOI12S0ADV12 -d $block_width $block_height $left_offset $bottom_offset $right_offset $top_offset
uiSetTool select
setFlipping f
redraw
fit;    # Fit design to window
win;    # Open Innovus GUI window

# Power Rings
addRing -nets { VSS VDD } -center 1 -layer {right M9 left M9 top M10 bottom M10} -width 8.0 -spacing 3
addRing -nets { VSS VDD } -center 1 -layer {right M7 left M7 top M8 bottom M8}   -width 2.8 -spacing 3
addRing -nets { VSS VDD } -center 1 -layer {right M5 left M5 top M6 bottom M6}   -width 2.0 -spacing 3
addRing -nets { VSS VDD } -center 1 -layer {right M3 left M3 top M4 bottom M4}   -width 1.4 -spacing 3

# Connect VDDPST/VSSPST to pads
globalNetConnect VDDPST -type pgpin -pin DVDD -inst PAD_POWER_D* -verbose
globalNetConnect VSSPST -type pgpin -pin DVSS -inst PAD_POWER_D* -verbose

# Connect and route VDD pad/ring
globalNetConnect VDD -type pgpin -pin VDD -inst PAD_POWER_VDD1 -verbose
sroute -inst {PAD_POWER_VDD1} -nets {VDD} -connect padPin -padPinPortConnect allGeom -allowJogging 0 -padPinLayerRange {5 10} -layerChangeRange {5 10} -crossoverViaLayerRange {5 10} -targetViaLayerRange {5 10} -area [list [expr $block_width - $io_pad_width - $right_offset] $right_offset $block_width $block_height]

# Connect and route VSS pad/ring
globalNetConnect VSS -type pgpin -pin VSS -inst PAD_POWER_VSS1 -verbose
sroute -inst {PAD_POWER_VSS1} -nets {VSS} -connect padPin -padPinPortConnect allGeom -allowJogging 0 -padPinLayerRange {5 10} -layerChangeRange {5 10} -crossoverViaLayerRange {5 10} -targetViaLayerRange {5 10} -area [list [expr $block_width - $io_pad_width - $right_offset] $right_offset $block_width $block_height]

connect_std_cells_to_power

# Power Stripes
setAddStripeMode -remove_floating_stripe_over_block 1 -merge_with_all_layers 1 -extend_to_first_ring 1 -route_over_rows_only 1 -allow_jog none -stacked_via_bottom_layer M4 -stacked_via_top_layer M9
addStripe -nets {VDD VSS} -layer M8 -direction {horizontal} -start $pstripe_start -stop $pstripe_stop -width 2.8 -spacing 3 -snap_wire_center_to_grid Grid -set_to_set_distance $pstripe_spacing
addStripe -nets {VDD VSS} -layer M7 -direction {vertical}   -start $pstripe_start -stop $pstripe_stop -width 2.8 -spacing 3 -snap_wire_center_to_grid Grid -set_to_set_distance $pstripe_spacing 
addStripe -nets {VDD VSS} -layer M6 -direction {horizontal} -start $pstripe_start -stop $pstripe_stop -width 2.0 -spacing 3 -snap_wire_center_to_grid Grid -set_to_set_distance $pstripe_spacing
addStripe -nets {VDD VSS} -layer M5 -direction {vertical}   -start $pstripe_start -stop $pstripe_stop -width 2.0 -spacing 3 -snap_wire_center_to_grid Grid -set_to_set_distance $pstripe_spacing

# Assign VDD/VSS
connect_std_cells_to_power

# saveDesign "${top_level}.floorplanned.enc"

# Route power and ground to cell tracks
sroute -nets {VDD VSS} -connect {corePin} -layerChangeRange {1 5} -allowJogging 0 -allowLayerChange 1 -crossoverViaLayerRange {1 5} -targetViaLayerRange {1 5}

############################################
# PLACE
############################################

set_dont_touch [get_cells outbuffer*]

setDesignMode -flowEffort high -process $process
setPrerouteAsObs {1}
timeDesign -prePlace

setPlaceMode -maxRouteLayer 9
placeDesign -noPrePlaceOpt
timeDesign -preCTS

setOptMode -holdTargetSlack 0.10 -holdFixingEffort high
setOptMode -addInst true -addInstancePrefix PRECTS_
optDesign -preCTS
congRepair

addTieHiLo -cell "TIEHI_X1M_A12TR TIELO_X1M_A12TR"

connect_std_cells_to_power

deleteEmptyModule

# saveDesign "${top_level}.placed.enc"

#####################################
# Clock Tree Synthesis
#####################################
# Create clock tree spec 
# add_ndr -name CTS_2W1S -width_multiplier {M3:M4 2} -generate_via
# add_ndr -name CTS_2W2S -spacing_multiplier {M5:M10 2} -width_multiplier {M5:M10 2} -generate_via

# create_route_type -name leaf_rule  -non_default_rule CTS_2W1S -top_preferred_layer M4  -bottom_preferred_layer M3
# create_route_type -name trunk_rule -non_default_rule CTS_2W2S -top_preferred_layer M7  -bottom_preferred_layer M5 -shield_net VSS -bottom_shield_layer M6
# create_route_type -name top_rule   -non_default_rule CTS_2W2S -top_preferred_layer M10 -bottom_preferred_layer M8 -shield_net VSS -bottom_shield_layer M8 
create_route_type -name leaf_rule  -top_preferred_layer M4  -bottom_preferred_layer M3
create_route_type -name trunk_rule -top_preferred_layer M7  -bottom_preferred_layer M5 -shield_net VSS -bottom_shield_layer M6
create_route_type -name top_rule   -top_preferred_layer M10 -bottom_preferred_layer M8 -shield_net VSS -bottom_shield_layer M8 

set_ccopt_property -net_type leaf  route_type leaf_rule
set_ccopt_property -net_type trunk route_type trunk_rule
set_ccopt_property -net_type top   route_type top_rule 

set_ccopt_property routing_top_min_fanout 10000

set_ccopt_property target_max_trans 100ps
set_ccopt_property target_skew      50ps

exec /bin/rm -f ${top_level}.cts
create_ccopt_clock_tree_spec -file ${top_level}.cts

ccopt_design -cts

setOptMode -restruct false -addInst true -addInstancePrefix POSCTS_ 
timeDesign -postCTS
optDesign -postCTS
optDesign -postCTS -hold

# saveDesign "${top_level}.ck_synth.enc"

# Connect any additional buffers
connect_std_cells_to_power

#####################################
# Signal Routing
#####################################
# Trial route
trialRoute -highEffort

setNanoRouteMode -envAlignNonPreferredTrack true
setNanoRouteMode -routeWithViaOnlyForStandardCellPin false
setNanoRouteMode -routeWithTimingDriven true
setNanoRouteMode -routeWithSiDriven true
setNanoRouteMode -routeSiEffort max
setNanoRouteMode -drouteAutoStop false
setNanoRouteMode -drouteUseMinSpacingForBlockage false
setNanoRouteMode -routeMergeSpecialWire true
setNanoRouteMode -drouteHonorStubRuleForBlockPin true
setNanoRouteMode -drouteUseMultiCutViaEffort high
setNanoRouteMode -routeTopRoutingLayer $top_routing_layer
setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeSelectedNetOnly false
setNanoRouteMode -routeWithViaInPin true

# Do both global and detail routing
globalDetailRoute
    
saveDesign ${top_level}.route.enc 

# Connect any filler cells to power/ground
connect_std_cells_to_power

###################################################
# Finalize the design
# Todo: this section could use some cleaning
###################################################
setDelayCalMode -SIAware false

# Check timing
setAnalysisMode -skew true -warn false -checkType hold
report_timing
setAnalysisMode -skew true -warn false -checkType setup -clockPropagation forcedIdeal
report_timing

timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50

# Shrink Area/Density and Fix Timing, Fanout, and Capacitance DRC violations
# setOptMode -effort high -powerEffort high -leakageToDynamicRatio 0.5 -yieldEffort none -reclaimArea true -simplifyNetlist true -setupTargetSlack 0 -holdTargetSlack 0.1 -maxDensity 0.95 -drcMargin 0 -usefulSkew false
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute
optDesign -postRoute -hold

# # Fix Antenna errors
# # Set the top metal lower than the maximum level to avoid adding diodes
# setNanoRouteMode -routeTopRoutingLayer $top_routing_layer
# setNanoRouteMode -routeInsertDiodeForClockNets true
# setNanoRouteMode -drouteFixAntenna true
# setNanoRouteMode -routeAntennaCellName "ANTENNA2A10TR"
# setNanoRouteMode -routeInsertAntennaDiode true
# setNanoRouteMode -drouteSearchAndRepair true 
# setNanoRouteMode -routeWithTimingDriven true
# setNanoRouteMode -routeWithSiDriven true

globalDetailRoute
optDesign -postRoute
optDesign -postRoute -hold
optDesign -postRoute -drv

# Add fill cells
addFiller -cell FILLDGCAP8_A12TR FILLDGCAP16_A12TR FILLDGCAP32_A12TR FILLDGCAP64_A12TR -prefix FILL

# Connect any filler cells to power/ground
connect_std_cells_to_power

# saveDesign "${top_level}.routed2.enc"

# Add IO Pad Fillers
# addIoFiller -cell PFILLER20 -prefix PAD_FILLER -side e
# addIoFiller -cell PFILLER10 -prefix PAD_FILLER -side e
# addIoFiller -cell PFILLER1  -prefix PAD_FILLER -side e
# addIoFiller -cell PFILLER05 -prefix PAD_FILLER -side e

###################################################
# Report and Output
###################################################
# Run some basic checks. We still have to run these with Calibre.
clearDrc
fixMinCutVia
fillNotch

# Run Geometry and Connection checks
verifyGeometry -reportAllCells -viaOverlap -report ${output_dir}/${top_level}.geom.rpt
verifyConnectivity -type all -noAntenna -report ${output_dir}/${top_level}.conn.rpt
reportPower

# Report Final Timing
setAnalysisMode -skew true -warn false -checkType hold
report_timing
setAnalysisMode -skew true -warn false -checkType setup -clockPropagation forcedIdeal
report_timing

# Save Design in Innovus format
saveDesign "${top_level}.final.enc"

# Generate SDF
setExtractRCMode -detail -relative_c_th 0.01 -total_c_th 0.01 -specialNet
extractRC -outfile ${output_dir}/${top_level}.cap
rcOut -spf ${output_dir}/${top_level}.spf
rcOut -spef ${output_dir}/${top_level}.spef
setUseDefaultDelayLimit 10000
delayCal -sdf ${output_dir}/${top_level}.sdf
reportClockTree -postRoute -macromodel report_postroute.ctsmdl
report_timing

# Output DEF
set dbgLefDefOutVersion 5.5
defOut -floorplan -netlist -routing ${output_dir}/${top_level}.def
    
# # Output LEF
lefout "${output_dir}/${top_level}.lef" -stripePin -PGpinLayers 1 2 3 4 5 6 7 8 9 10
# write_lef_abstract

# Output GDSII
#setStreamOutMode -snapToMGrid true -virtualConnection false
streamOut ${output_dir}/$top_level.gds -mapFile ${map_file_path}

# Output Netist
saveNetlist -excludeLeafCell ${output_dir}/netlists/${top_level}.par.nl.v
saveNetlist -excludeLeafCell -lineLength 10000000 -includePowerGround -includePhysicalInst ${output_dir}/netlists/${top_level}.par.physical.nl.v
saveNetlist -excludeLeafCell -lineLength 10000000 -includePowerGround -includePhysicalCell {FILLDGCAP8_A12TR FILLDGCAP16_A12TR FILLDGCAP32_A12TR FILLDGCAP64_A12TR} ${output_dir}/netlists/${top_level}.par.incPG.nl.v

# Generate .lib
do_extract_model ${output_dir}/${top_level}.lib

puts "**************************************"
puts "*                                    *"
puts "* Innovus script finished            *"
puts "*                                    *"
puts "**************************************"

# exit
