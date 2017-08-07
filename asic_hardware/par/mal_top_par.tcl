###################################
# Author: Timothy Trippel
# Last Edited: August 2017
###################################
set global_config mal_top.globals
set syn_root  	  /home/ttrippel/A2/asic_hardware/netlist
set tech_root 	  /home/cadlib/Processes/IBM/STANDARD_CELLS/Virage/cp65npksdsta03
set par_root  	  /home/ttrippel/A2/asic_hardware/par

###################################
# CONFIG
###################################
set top_level     MAL_TOP
set process       45;  # nm
set io_pad_width  130; # width of IO pad in microns

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
# ######################################################################################################

# Power Stripes
setAddStripeMode -remove_floating_stripe_over_block 1 -merge_with_all_layers 1 -extend_to_first_ring 1 -route_over_rows_only 1 -allow_jog none -stacked_via_bottom_layer M4 -stacked_via_top_layer M9
addStripe -nets {VDD VSS} -layer M8 -direction {horizontal} -start $pstripe_start -stop $pstripe_stop -width 2.8 -spacing 3 -snap_wire_center_to_grid Grid -set_to_set_distance $pstripe_spacing
addStripe -nets {VDD VSS} -layer M7 -direction {vertical}   -start $pstripe_start -stop $pstripe_stop -width 2.8 -spacing 3 -snap_wire_center_to_grid Grid -set_to_set_distance $pstripe_spacing 
addStripe -nets {VDD VSS} -layer M6 -direction {horizontal} -start $pstripe_start -stop $pstripe_stop -width 2.0 -spacing 3 -snap_wire_center_to_grid Grid -set_to_set_distance $pstripe_spacing
addStripe -nets {VDD VSS} -layer M5 -direction {vertical}   -start $pstripe_start -stop $pstripe_stop -width 2.0 -spacing 3 -snap_wire_center_to_grid Grid -set_to_set_distance $pstripe_spacing

# Assign VDD/VSS
connect_std_cells_to_power

# saveDesign "${top_level}.pads_routed.enc"

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
setOptMode -addInst true -addInstancePrefix PRECTS
optDesign -preCTS
congRepair

addTieHiLo -cell "TIEHI_X1M_A12TR TIELO_X1M_A12TR"

connect_std_cells_to_power
# saveDesign "${top_level}.placed.enc"
deleteEmptyModule

#####################################
# Clock Tree Synthesis
#####################################
# #create_clock  PAD_u0_digin/ZI -period 1
# #Create clock tree spec

# setCTSMode \
#    -traceDPinAsLeaf true \
#    -traceIoPinAsLeaf true \
#    -routeBottomPreferredLayer 3 \
#    -routeTopPreferredLayer 6 \
#    -addClockRootProp true
# exec /bin/rm -f ${top_level}.cts
# createClockTreeSpec -output ${top_level}.cts
# exec sed -i -r "s/^MaxDelay .*/MaxDelay 120ps/g" ${top_level}.cts
# exec sed -i -r "s/^MaxSkew .*/MaxSkew 50ps/g" ${top_level}.cts
# exec sed -i -r "s/END/RootInputTran 100ps\\nEND/g" ${top_level}.cts
# exec sed -i -r "s/^RouteClkNet .*//g" ${top_level}.cts

# specifyClockTree -file ${top_level}.cts

# ckSynthesis \
#     -rguide ${top_level}.cts.rguide \
#     -report ${top_level}.ctsrpt \
#     -macromodel ${top_level}.ctsmdl \
#     -forceReconvergent

# setOptMode -restruct false -congOpt true -addInst true -addInstancePrefix POSCTS_ 
# timeDesign -postCTS

# optDesign -postCTS
# optDesign -postCTS -hold

# #optDesign -postCTS -idealClock
# #optDesign -postCTS -drv -idealClock
# #optDesign -postCTS -hold -idealClock

# saveDesign "${top_level}.ck_synth.enc"

# # Connect any additional buffers
# connect_std_cells_to_power
# #sroute -nets {VDD VSS} -connect corePin -allowJogging 0

# #####################################
# # Signal Routing
# #####################################
# # Trial route
# trialRoute -highEffort

# #setNanoRouteMode -routeWithViaInPin true
# #setNanoRouteMode -drouteOnGridOnly via
# setNanoRouteMode -envAlignNonPreferredTrack true
# #setNanoRouteMode -routeWithEco true
# setNanoRouteMode -routeWithViaOnlyForStandardCellPin false

# #####
# setNanoRouteMode -routeWithTimingDriven true
# setNanoRouteMode -routeWithSiDriven true
# setNanoRouteMode -routeSiEffort max
# #####

# setNanoRouteMode -drouteAutoStop false
# setNanoRouteMode -drouteUseMinSpacingForBlockage false
# setNanoRouteMode -routeMergeSpecialWire true
# setNanoRouteMode -drouteHonorStubRuleForBlockPin true
# setNanoRouteMode -drouteUseMinSpacingForBlockage false
# setNanoRouteMode -drouteUseMultiCutViaEffort high
# setNanoRouteMode -routeTopRoutingLayer 8
# setNanoRouteMode -routeBottomRoutingLayer 1
# setNanoRouteMode -routeSelectedNetOnly false

# #####
# setNanoRouteMode -quiet -routeWithViaInPin true
# #####


# # Do both global and detail routing
# globalDetailRoute
    
#     saveDesign ${top_level}.route.enc 

# # Connect any filler cells to power/ground
# connect_std_cells_to_power


# ###################################################
# # Finalize the design
# # Todo: this section could use some cleaning
# ###################################################

# # Check timing
# setAnalysisMode -skew -noWarn -checkType hold
# report_timing
# setAnalysisMode -skew -noWarn -setup -clockPropagation forcedIdeal
# report_timing


# timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix RNG_TOP_PAD_NEW_postRoute -outDir timingReports
# #setOptMode -effort high -leakagePowerEffort high -dynamicPowerEffort high -yieldEffort none -reclaimArea true -simplifyNetlist true -setupTargetSlack 0 -holdTargetSlack 0.1 -maxDensity 0.95 -drcMargin 0 -usefulSkew false
# setOptMode -fixCap true -fixTran true -fixFanoutLoad true
# optDesign -postRoute
# setOptMode -fixCap true -fixTran true -fixFanoutLoad true
# optDesign -postRoute
# optDesign -postRoute -hold

# # Fix Antenna errors
# # Set the top metal lower than the maximum level to avoid adding diodes
# setNanoRouteMode -routeTopRoutingLayer 8
# setNanoRouteMode -routeInsertDiodeForClockNets true
# setNanoRouteMode -drouteFixAntenna true
# setNanoRouteMode -routeAntennaCellName "ANTENNA2A10TR"
# setNanoRouteMode -routeInsertAntennaDiode true
# setNanoRouteMode -drouteSearchAndRepair true 
# setNanoRouteMode -routeWithTimingDriven true
# setNanoRouteMode -routeWithSiDriven true

# globalDetailRoute
# optDesign -postRoute
# optDesign -postRoute -hold
# optDesign -postRoute -drv

# deleteObstruct -all
# # Add fill cells
# addFiller -cell FILLCAPTIE128A10TR FILLCAPTIE64A10TR FILLCAPTIE32A10TR FILLCAPTIE16A10TR FILLCAPTIE9A10TR FILLCAPTIE8A10TR -prefix FILLCAPTIE
# addFiller -cell FILLCAP128A10TR FILLCAP65A10TR FILLCAP32A10TR FILLCAP17A10TR FILLCAP8A10TR FILLCAP6A10TR -prefix FILLCAP
# addFiller -cell FILL128A10TR FILL64A10TR FILL32A10TR FILL16A10TR FILL8A10TR FILL4A10TH FILL2A10TR FILL1A10TR -prefix FILL

# # Connect any filler cells to power/ground
# connect_std_cells_to_power
# #sroute -nets {VDD VSS} -connect corePin -allowJogging 0
# #saveDesign "${top_level}.routed2.enc"

# # Delete halos (not applicable to this design, but we leave it here.
# #deleteHaloFromBlock -allBlock
# saveDesign "${top_level}.routed2.enc"

# addIoFiller -cell PFILLER20 -prefix PAD_FILLER -side e
# addIoFiller -cell PFILLER10  -prefix PAD_FILLER -side e
# addIoFiller -cell PFILLER1      -prefix PAD_FILLER -side e
# addIoFiller -cell PFILLER05    -prefix PAD_FILLER -side e

# ###################################################
# # Report and Output
# ###################################################
# #stooopp


# # Run some basic checks. We still have to run these with Calibre.
# clearDrc
# verifyGeometry -reportAllCells -viaOverlap -report ${top_level}.geom.rpt
# fixMinCutVia
# fillNotch
# verifyGeometry -reportAllCells -viaOverlap -report ${top_level}.geom.rpt

# verifyConnectivity -type all -noAntenna -report ${top_level}.conn.rpt
# reportPower

# # Run Geometry and Connection checks
# setAnalysisMode -skew -noWarn -hold
# report_timing
# setAnalysisMode -skew -noWarn -setup -clockPropagation forcedIdeal
# report_timing
# saveDesign "${top_level}.final.enc"

# # Generate SDF
# setExtractRCMode -detail -relative_c_th 0.01 -total_c_th 0.01 -specialNet
# extractRC -outfile ${top_level}.cap
# rcOut -spf ${top_level}.spf
# rcOut -spef ${top_level}.spef
# setUseDefaultDelayLimit 10000
# delayCal -sdf ${top_level}.apr.sdf
# reportClockTree -postRoute -macromodel report_postroute.ctsmdl
# #Generate SDF
# #setExtractRCMode -engine detail -coupling_c_th 0 -coupled true
# #extractRC
# report_timing
# #saveDesign "${top_level}.final_filled.enc"


# # Output DEF
# set dbgLefDefOutVersion 5.5
# defOut -floorplan -netlist -routing ${top_level}.apr.def
    
# # Output LEF
# lefout "$top_level.lef" -stripePin -PGpinLayers 1 2 3 4 5 6 7 8 9 

# # Output GDSII
# #setStreamOutMode -snapToMGrid true -virtualConnection false
# streamOut $top_level.gds -mapFile ../TSMC65.mapOut
# #-libName ${top_level} -structureName $top_level -mode ALL 

# # Output Netist
# saveNetlist -excludeLeafCell ${top_level}.apr.v
# saveNetlist -excludeLeafCell -lineLength 10000000 -includePowerGround -includePhysicalInst ${top_level}.apr.physical.v
# saveNetlist -excludeLeafCell -lineLength 10000000 -includePowerGround -includePhysicalCell { FILLCAPTIE8A10TR FILLCAPTIE16A10TR FILLCAPTIE32A10TR FILLCAPTIE64A10TR FILLCAPTIE128A10TR} ${top_level}.apr.incPG.v

# # Generate .lib
# do_extract_model ${top_level}.lib

# # Convert .lib to .db
# #dc_shell
# #read_lib descriptor.lib 
# #write_lib descriptor -f db -output descriptor.db
# #quit
# #exec ../../bin/lib_to_db.sh ${top_level}

# puts "**************************************"
# puts "*                                    *"
# puts "* Encounter script finished          *"
# puts "*                                    *"
# puts "**************************************"

# exit
