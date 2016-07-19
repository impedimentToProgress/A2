###################################
# Author: Kaiyuan Yang
# Last Edited: May 2014
###################################
set syn_root /XXX/syn
set tech_root /XXX
set apr_root ./apr/
set SRAM_PATH 	/XXX/sram

###################################
# CONFIG
###################################
set top_level MAL_TOP
set block_width 1300
set block_height 1300
#set block_width [expr 600*0.136]
#set block_height_rows 30
#set block_height [expr $block_height_rows*1.2]
set left_offset 80
set right_offset 80
set top_offset 80
set bottom_offset 100
# Allow manual footprint declarations in conf file
#set dbgGPSAutoCellFunction 0

###################################
# Misc Functions
###################################

#proc get_multithread_lic { } {
  getMultiCpuLicense 8
  setMultiCpuUsage -acquireLicense 8
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
loadConfig ./${top_level}.conf 
#source ./apr_views.tcl
###################################
# Floorplan
###################################

# Initial floorplan

#getIoFlowFlag
#setIoFlowFlag 0
#floorPlan -site TSMC65ADV10TSITE -d $block_width $block_height $left_offset $bottom_offset $right_offset $top_offset
##loadIoFile -noAdjustDieSize ${top_level}.io
#uiSetTool select
#getIoFlowFlag
#setFlipping s
#redraw
#fit
#win

addRing -nets { VSS VDD VSS VDDTEST CVDD} -around core -center 1 -layer_right M8 -layer_left M8 -layer_top M7 -layer_bottom M7 -width_top 6 -width_bottom 6 -width_left 6 -width_right 6 -spacing_top 4 -spacing_bottom 4 -spacing_right 4 -spacing_left 4
addRing -nets { VSS VDD VSS VDDTEST CVDD} -around core -center 1 -layer_right M6 -layer_left M6 -layer_top M5 -layer_bottom M5 -width_top 6 -width_bottom 6 -width_left 6 -width_right 6 -spacing_top 4 -spacing_bottom 4 -spacing_right 4 -spacing_left 4
addRing -nets { VSS VDD VSS VDDTEST CVDD} -around core -center 1 -layer_right M4 -layer_left M4 -layer_top M3 -layer_bottom M3 -width_top 6 -width_bottom 6 -width_left 6 -width_right 6 -spacing_top 4 -spacing_bottom 4 -spacing_right 4 -spacing_left 4

#addIoFiller -cell PFILLER20 -prefix PAD_FILLER -side w
#addIoFiller -cell PFILLER10  -prefix PAD_FILLER -side w
#addIoFiller -cell PFILLER1      -prefix PAD_FILLER -side w
#addIoFiller -cell PFILLER05    -prefix PAD_FILLER -side w
#addIoFiller -cell PFILLER0005    -prefix PAD_FILLER -side w -fillAnyGap
#
#addIoFiller -cell PFILLER20 -prefix PAD_FILLER -side n
#addIoFiller -cell PFILLER10  -prefix PAD_FILLER -side n
#addIoFiller -cell PFILLER1      -prefix PAD_FILLER -side n
#addIoFiller -cell PFILLER05    -prefix PAD_FILLER -side n
#addIoFiller -cell PFILLER0005    -prefix PAD_FILLER -side n -fillAnyGap
#
#addIoFiller -cell PFILLER20 -prefix PAD_FILLER -side e
#addIoFiller -cell PFILLER10  -prefix PAD_FILLER -side e
#addIoFiller -cell PFILLER1      -prefix PAD_FILLER -side e
#addIoFiller -cell PFILLER05    -prefix PAD_FILLER -side e
#addIoFiller -cell PFILLER0005    -prefix PAD_FILLER -side e -fillAnyGap
#
#addIoFiller -cell PFILLER20 -prefix PAD_FILLER -side s
#addIoFiller -cell PFILLER10  -prefix PAD_FILLER -side s
#addIoFiller -cell PFILLER1      -prefix PAD_FILLER -side s
#addIoFiller -cell PFILLER05    -prefix PAD_FILLER -side s
#addIoFiller -cell PFILLER0005    -prefix PAD_FILLER -side s -fillAnyGap


saveDesign "${top_level}.init.enc"

placeInstance orpsoc/ram_wb0/ram_wb_b3_0/u__tmp118/mem_block_32K_32 51 80 R90
placeInstance orpsoc/or1200_top0/or1200_ic_top/or1200_ic_ram/ic_ram0/rf 941 750
placeInstance clk_gen0 950 900
placeInstance test1 1000 970
placeInstance test_structure 1070 970
#placeInstance orpsoc/ram_wb0/ram_wb_b3_0/u__tmp118/mem_block_32K_32 44.0405 507.5085 MX

addHaloToBlock 3 3 3 3 orpsoc/ram_wb0/ram_wb_b3_0/u__tmp118/mem_block_32K_32
addHaloToBlock 3 3 3 3 orpsoc/or1200_top0/or1200_ic_top/or1200_ic_ram/ic_ram0/rf
addHaloToBlock 3 3 3 3 clk_gen0
addHaloToBlock 3 3 40 3 test_structure
addHaloToBlock 3 3 40 3 test1

setAddStripeMode  -remove_floating_stripe_over_block 1 -merge_with_all_layers 1 -extend_to_first_ring 1 -route_over_rows_only 1

#addRing -nets { VDD VSS} -around core -offset_top 10 -offset_left 10 -offset_right 10 -offset_bottom 10 -layer_right M8 -layer_left M8 -layer_top M7 -layer_bottom M7 -width_top 10 -width_bottom 10 -width_left 10 -width_right 10 -spacing_top 4.5 -spacing_bottom 4.5 -spacing_right 4.5 -spacing_left 4.5


#PAD_Corner
globalNetConnect VDDPST -type pgpin -pin VDDPST -inst PAD_POWER_D* -verbose
globalNetConnect VSSPST -type pgpin -pin VSSPST -inst PAD_POWER_D* -verbose

#VDD
globalNetConnect VDD -type pgpin -pin VDD -inst PAD_POWER_VDD1 -verbose
sroute -block {PAD_POWER_VDD1} -nets {VDD} -connect padPin -padPinPortConnect allGeom -area {1100 200 1250 1300} -padPinMinLayer M1 -allowJogging 0 -layerChangeRange {M1 M8}

#VSS
globalNetConnect VSS -type pgpin -pin VSS -inst PAD_POWER_VSS1 -verbose
sroute -block {PAD_POWER_VSS1 } -nets {VSS} -connect padPin -padPinPortConnect allGeom -area {1170 200 1250 1300} -connectInsideArea

#VDDTEST
globalNetConnect VDDTEST -type pgpin -pin AVDD -inst PAD_POWER_AVDD -verbose
sroute -block {PAD_POWER_AVDD} -nets {VDDTEST} -connect padPin -padPinPortConnect allGeom  -area {1100 200 1250 1300}

#VSS
globalNetConnect VSS -type pgpin -pin AVSS -inst PAD_POWER_AVSS -verbose
sroute -block { PAD_POWER_AVSS } -nets {VSS} -connect padPin -padPinPortConnect allGeom  -area {1100 200 1250 1300}

#CVDD
globalNetConnect CVDD -type pgpin -pin AVDD -inst PAD_POWER_VDD2 -verbose
sroute -block {PAD_POWER_VDD2} -nets {CVDD} -connect padPin -padPinPortConnect allGeom  -area {1100 200 1250 1300}

#INPUT/OUTPUT PADS

globalNetConnect CVDD -type pgpin -pin VDDPE -inst *mem_block_32K_32 -verbose
globalNetConnect CVDD -type pgpin -pin VDDCE -inst *mem_block_32K_32 -verbose
globalNetConnect VSS -type pgpin -pin VSSE -inst *mem_block_32K_32 -verbose
globalNetConnect VDD -type pgpin -pin VDDPE -inst *rf -verbose
globalNetConnect VDD -type pgpin -pin VDDCE -inst *rf -verbose
globalNetConnect VSS -type pgpin -pin VSSE -inst *rf -verbose
globalNetConnect VDD -type pgpin -pin VDD -inst clk_gen0 -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst clk_gen0 -verbose
globalNetConnect VDDTEST -type pgpin -pin VDD -inst test1 -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst test1 -verbose
globalNetConnect VDDTEST -type pgpin -pin VDD -inst test_structure -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst test_structure -verbose
#globalNetConnect ana_test_bias -type pgpin -pin AVDD -inst PAD_ANA1 -verbose
#globalNetConnect ana_test_bias -type pgpin -pin Stress_Bias -inst test_structure  -verbose

connect_std_cells_to_power
######################################################################################################
setAnalog -net ana_*
setAttribute -net ana_* -preferred_extra_space 3
#sroute -nets {ana_test_bias} -padPinPortConnect allGeom  -area {1050 200 1250 1300}

addStripe -nets {CVDD VSS} -layer M8 -direction {vertical} -start_x 100 -stop_x 870 -width 6 -spacing 6 -allow_jog_block_ring 0 -stacked_via_bottom_layer M7 -stacked_via_top_layer M9 -snap_wire_center_to_grid Grid -set_to_set_distance 100

addStripe -nets {CVDD VSS} -layer M7 -direction {horizontal} -width 6  -spacing 6 -allow_jog_block_ring 0 -stacked_via_bottom_layer M6 -stacked_via_top_layer M8  -snap_wire_center_to_grid Grid -set_to_set_distance 200 -start_y 180.8

addStripe -nets {CVDD VSS} -layer M6 -direction {vertical} -start_x 100 -stop_x 870 -width 5 -spacing 6.2 -allow_jog_block_ring 0 -stacked_via_bottom_layer M5 -stacked_via_top_layer M7 -snap_wire_center_to_grid Grid -set_to_set_distance 100

addStripe -nets {CVDD VSS} -layer M5 -direction {horizontal} -width 5  -spacing 6 -allow_jog_block_ring 0 -stacked_via_bottom_layer M4 -stacked_via_top_layer M6  -snap_wire_center_to_grid Grid -set_to_set_distance 100 -start_y 160

editCutWire -x1 817.2955 -y1 1137.7205 -x2 817.2955 -y2 100.717

selectWire 817.2950 160.0000 1200.5000 165.0000 5 CVDD
selectWire 817.2950 171.0000 1180.5000 176.0000 5 VSS
selectWire 817.2950 271.0000 1180.5000 276.0000 5 VSS
selectWire 817.2950 260.0000 1200.5000 265.0000 5 CVDD
selectWire 817.2950 371.0000 1180.5000 376.0000 5 VSS
selectWire 817.2950 360.0000 1200.5000 365.0000 5 CVDD
selectWire 817.2950 460.0000 1152.2000 465.0000 5 CVDD
selectWire 817.2950 471.0000 1162.2500 476.0000 5 VSS
selectWire 1147.2000 446.6000 1152.2000 465.0000 6 CVDD
selectWire 1147.2000 446.6000 1200.5000 451.6000 5 CVDD
selectWire 817.2950 660.0000 1200.5000 665.0000 5 CVDD
selectWire 817.2950 671.0000 1180.5000 676.0000 5 VSS
selectWire 817.2950 560.0000 1200.5000 565.0000 5 CVDD
selectWire 817.2950 571.0000 1180.5000 576.0000 5 VSS
selectWire 817.2950 760.0000 1200.5000 765.0000 5 CVDD
selectWire 817.2950 771.0000 1180.5000 776.0000 5 VSS
selectWire 817.2950 860.0000 1200.5000 865.0000 5 CVDD
selectWire 817.2950 871.0000 1180.5000 876.0000 5 VSS
selectWire 817.2950 960.0000 1200.5000 965.0000 5 CVDD
selectWire 1032.1900 971.0000 1180.5000 976.0000 5 VSS
selectWire 817.2950 1060.0000 1192.2000 1065.0000 5 CVDD
selectWire 817.2950 1071.0000 1180.5000 1076.0000 5 VSS
deleteSelectedFromFPlan
selectWire 817.2950 971.0000 997.7500 976.0000 5 VSS
deleteSelectedFromFPlan


#addStripe -nets {CVDD VSS} -layer M4 -direction {vertical} -start_x 980 -stop_x 1000 -width 5 -spacing 5 -allow_jog_block_ring 0 -stacked_via_bottom_layer M3 -stacked_via_top_layer M5 -snap_wire_center_to_grid Grid -set_to_set_distance 100

#addStripe -nets {VDD VSS} -layer M4 -direction {vertical} -start_x 0 -stop_x 1500 -width 5 -spacing 5 -allow_jog_block_ring 0 -stacked_via_bottom_layer M3 -stacked_via_top_layer M5 -snap_wire_center_to_grid Grid -set_to_set_distance 60


addStripe -nets {VDD VSS} -layer M8 -direction {vertical} -start_x 870 -stop_x 1200 -width 5 -spacing 5 -allow_jog_block_ring 0 -stacked_via_bottom_layer M7 -stacked_via_top_layer M9 -snap_wire_center_to_grid Grid -set_to_set_distance 200

addStripe -nets {VDD} -layer M7 -direction {horizontal} -width 5  -spacing 5 -allow_jog_block_ring 0 -stacked_via_bottom_layer M6 -stacked_via_top_layer M8 -snap_wire_center_to_grid Grid -set_to_set_distance 200 -start_y 155.6

addStripe -nets {VDD VSS} -layer M6 -direction {vertical} -start_x 870 -stop_x 1200 -width 5 -spacing 5 -allow_jog_block_ring 0 -stacked_via_bottom_layer M3 -stacked_via_top_layer M7 -snap_wire_center_to_grid Grid -set_to_set_distance 100


#addStripe -nets {VDD VSS} -layer M5 -direction {horizontal} -width 3  -spacing 3 -allow_jog_block_ring 0 -stacked_via_bottom_layer M4 -stacked_via_top_layer M6 -snap_wire_center_to_grid Grid -set_to_set_distance 60 -start_y 20
#addStripe -nets {VDD VSS} -layer M5 -direction {horizontal} -width 3  -spacing 3 -allow_jog_block_ring 0 -stacked_via_bottom_layer M4 -stacked_via_top_layer M6  -snap_wire_center_to_grid Grid -set_to_set_distance 50


# Assign VDD/VSS
#clearGlobalNets
connect_std_cells_to_power

saveDesign "${top_level}.pads_routed.enc"

#sroute -connect { corePin } -layerChangeRange { M1 M8 } -blockPinTarget { nearestTarget } -deleteExistingRoutes -checkAlignedSecondaryPin 1 -allowJogging 0 -crossoverViaBottomLayer M1 -allowLayerChange 1 -targetViaTopLayer M8 -crossoverViaTopLayer M8 -targetViaBottomLayer M1 -area { 817 48 1200 1250 } -nets { VDD VSS } -viaConnectToShape { ring stripe }

#VDDTEST
addStripe -nets {VDDTEST VSS} -layer M7 -direction {horizontal} -width 5  -spacing 5 -allow_jog_block_ring 0 -stacked_via_bottom_layer M4 -stacked_via_top_layer M8  -snap_wire_center_to_grid Grid -set_to_set_distance 100 -start_y 1030 -stop_y 1060

addStripe -nets {VDDTEST VSS} -layer M4 -direction {vertical} -start_x 1100 -width 5 -spacing 5 -allow_jog_block_ring 0 -stacked_via_bottom_layer M3 -stacked_via_top_layer M5 -snap_wire_center_to_grid Grid -set_to_set_distance 90
addStripe -nets {VDDTEST VSS} -layer M6 -direction {vertical} -start_x 1010 -width 5 -spacing 5 -allow_jog_block_ring 0 -stacked_via_bottom_layer M5 -stacked_via_top_layer M7 -snap_wire_center_to_grid Grid -set_to_set_distance 200


windowSelect 1152.300 -113.496 753.006 -225.299
uiSetTool cutWire
editCutWire -x1 1009.6995 -y1 969.8695 -x2 1025.2125 -y2 969.8695
uiSetTool select
selectWire 1010.0000 12.0000 1015.0000 969.8700 6 VDDTEST
deleteSelectedFromFPlan
selectWire 1020.0000 22.0000 1025.0000 969.8700 6 VSS
deleteSelectedFromFPlan
uiSetTool cutWire
editCutWire -x1 1099.371 -y1 969.393 -x2 1116.4805 -y2 969.393
uiSetTool select
selectWire 1100.0000 12.0000 1105.0000 969.3950 4 VDDTEST
deleteSelectedFromFPlan
selectWire 1110.0000 22.0000 1115.0000 969.3950 4 VSS
deleteSelectedFromFPlan

#sroute -connect { corePin } -layerChangeRange { M1 M8 } -blockPinTarget { nearestTarget } -allowJogging 0 -crossoverViaBottomLayer M1 -allowLayerChange 1 -targetViaTopLayer M8 -crossoverViaTopLayer M8 -targetViaBottomLayer M1 -nets { VDD VSS } -area {817 48 1200 1250} -connectInsideArea

sroute -connect { corePin } -layerChangeRange { M1 M6 } -allowJogging 0 -crossoverViaBottomLayer M1 -allowLayerChange 1 -targetViaTopLayer M6 -crossoverViaTopLayer M6 -area { 817 48 1173 1250 } -targetViaBottomLayer M1 -nets { VDD VSS } -connectInsideArea

sroute -connect { corePin } -allowJogging 0 -nets { VDD VSS } -area {0 1208 850 1250} -connectInsideArea
sroute -connect { corePin } -allowJogging 0 -nets { VDD VSS } -area {0 0 850 78} -connectInsideArea


#sroute -nets {VSS VDD} -connect {blockPin} -allowLayerChange {1} -corePinLayer {1} -corePinMaxViaWidth 90 -crossoverViaBottomLayer 1 -crossoverViaTopLayer 2 -targetViaBottomLayer 1 -targetViaTopLayer 2 -blockPinMaxLayer 2 -blockPinMinLayer 1 -corePinNoRouteEmptyRows -blockPinRouteWithPinWidth -blockPinTarget {nearestRingStripe} -verbose
#
#sroute -nets {VSS VDD}  -corePinLayer {1} -crossoverViaBottomLayer 1 -crossoverViaTopLayer 1 -targetViaBottomLayer 1 -targetViaTopLayer 1 -blockPinMaxLayer 1 -blockPinMinLayer 1 -noPadRings -stopBlockPin {boundaryWithPin} -verbose

############################################
# PLACE
############################################

# Load pins
#loadIoFile ${top_level}.io
# Place welltaps
addWellTap -cell FILLTIE2A10TR -maxGap 27 -prefix FILLTIE 
#-pitch 10

saveDesign "${top_level}.power.enc"
createObstruct 870 56 1120 320

set_dont_touch [get_nets ana*]
set_dont_touch [get_cells -hierarchical *DTL_*]
set_dont_touch [get_cells RNG_top/DUT*/D*/DT_ro*]
set_dont_touch [get_cells outbuffer*]

set_false_path -from [get_ports *scan_* ]
set_false_path -to [get_ports *scan_* ]
#set_false_path -to [get_ports RNG_top/*count_MSB_out]
#set_false_path -through [get_cells */*/*/*DT*]
#set_false_path -through [get_cells */*/*/pfd* ]
#set_false_path -through [get_cells */*/*/pg* ]
#set_false_path -through [get_cells */msb_divider ]
#set_false_path -through [get_cells RNG_top/msb_divider/I0_0_/I1 ]
#set_false_path -through [get_nets RNG_top/*/rng* ]
#set_false_path -through [get_nets RNG_top/*/count_MSB_d2 ]


setDesignMode -flowEffort high -process 65
setPrerouteAsObs {1}
timeDesign -prePlace

setPlaceMode -maxRouteLayer 8
#setPlaceMode -congEffort high
placeDesign -noPrePlaceOpt
timeDesign -preCTS

setOptMode -holdTargetSlack 0.10 -holdFixingEffort high
setOptMode -addInst true -addInstancePrefix PRECTS
optDesign -preCTS
congRepair

addTieHiLo -cell "TIEHIX1MA10TR TIELOX1MA10TR"

connect_std_cells_to_power
saveDesign "${top_level}.placed.enc"
deleteEmptyModule
stop

#####################################
# Clock Tree Synthesis
#####################################
#create_clock  PAD_u0_digin/ZI -period 1
#Create clock tree spec

#setCTSMode \
#    -traceDPinAsLeaf true \
#    -traceIoPinAsLeaf true \
#    -bottomPreferredLayer 3 \
#    -topPreferredLayer 6 \
#    -addClockRootProp true
#exec /bin/rm -f ${top_level}.cts
#createClockTreeSpec -output ${top_level}.cts
#exec sed -i -r "s/^MaxDelay .*/MaxDelay 120ps/g" ${top_level}.cts
#exec sed -i -r "s/^MaxSkew .*/MaxSkew 50ps/g" ${top_level}.cts
#exec sed -i -r "s/END/RootInputTran 100ps\\nEND/g" ${top_level}.cts
#exec sed -i -r "s/^RouteClkNet .*//g" ${top_level}.cts

specifyClockTree -file ${top_level}.cts

ckSynthesis \
    -rguide ${top_level}.cts.rguide \
    -report ${top_level}.ctsrpt \
    -macromodel ${top_level}.ctsmdl \
    -forceReconvergent

setOptMode -restruct false -congOpt true -addInst true -addInstancePrefix POSCTS_ 
timeDesign -postCTS

optDesign -postCTS
optDesign -postCTS -hold

#optDesign -postCTS -idealClock
#optDesign -postCTS -drv -idealClock
#optDesign -postCTS -hold -idealClock

saveDesign "${top_level}.ck_synth.enc"

# Connect any additional buffers
connect_std_cells_to_power
#sroute -nets {VDD VSS} -connect corePin -allowJogging 0

#####################################
# Signal Routing
#####################################
# Trial route
trialRoute -highEffort

#setNanoRouteMode -routeWithViaInPin true
#setNanoRouteMode -drouteOnGridOnly via
setNanoRouteMode -envAlignNonPreferredTrack true
#setNanoRouteMode -routeWithEco true
setNanoRouteMode -routeWithViaOnlyForStandardCellPin false

#####
setNanoRouteMode -routeWithTimingDriven true
setNanoRouteMode -routeWithSiDriven true
setNanoRouteMode -routeSiEffort max
#####

setNanoRouteMode -drouteAutoStop false
setNanoRouteMode -drouteUseMinSpacingForBlockage false
setNanoRouteMode -routeMergeSpecialWire true
setNanoRouteMode -drouteHonorStubRuleForBlockPin true
setNanoRouteMode -drouteUseMinSpacingForBlockage false
setNanoRouteMode -drouteUseMultiCutViaEffort high
setNanoRouteMode -routeTopRoutingLayer 8
setNanoRouteMode -routeBottomRoutingLayer 1
setNanoRouteMode -routeSelectedNetOnly false

#####
setNanoRouteMode -quiet -routeWithViaInPin true
#####


# Do both global and detail routing
globalDetailRoute
    
    saveDesign ${top_level}.route.enc 

# Connect any filler cells to power/ground
connect_std_cells_to_power


###################################################
# Finalize the design
# Todo: this section could use some cleaning
###################################################

# Check timing
setAnalysisMode -skew -noWarn -checkType hold
report_timing
setAnalysisMode -skew -noWarn -setup -clockPropagation forcedIdeal
report_timing


timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix RNG_TOP_PAD_NEW_postRoute -outDir timingReports
#setOptMode -effort high -leakagePowerEffort high -dynamicPowerEffort high -yieldEffort none -reclaimArea true -simplifyNetlist true -setupTargetSlack 0 -holdTargetSlack 0.1 -maxDensity 0.95 -drcMargin 0 -usefulSkew false
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute
optDesign -postRoute -hold

# Fix Antenna errors
# Set the top metal lower than the maximum level to avoid adding diodes
setNanoRouteMode -routeTopRoutingLayer 8
setNanoRouteMode -routeInsertDiodeForClockNets true
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeAntennaCellName "ANTENNA2A10TR"
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -drouteSearchAndRepair true 
setNanoRouteMode -routeWithTimingDriven true
setNanoRouteMode -routeWithSiDriven true

globalDetailRoute
optDesign -postRoute
optDesign -postRoute -hold
optDesign -postRoute -drv

deleteObstruct -all
# Add fill cells
addFiller -cell FILLCAPTIE128A10TR FILLCAPTIE64A10TR FILLCAPTIE32A10TR FILLCAPTIE16A10TR FILLCAPTIE9A10TR FILLCAPTIE8A10TR -prefix FILLCAPTIE
addFiller -cell FILLCAP128A10TR FILLCAP65A10TR FILLCAP32A10TR FILLCAP17A10TR FILLCAP8A10TR FILLCAP6A10TR -prefix FILLCAP
addFiller -cell FILL128A10TR FILL64A10TR FILL32A10TR FILL16A10TR FILL8A10TR FILL4A10TH FILL2A10TR FILL1A10TR -prefix FILL

# Connect any filler cells to power/ground
connect_std_cells_to_power
#sroute -nets {VDD VSS} -connect corePin -allowJogging 0
#saveDesign "${top_level}.routed2.enc"

# Delete halos (not applicable to this design, but we leave it here.
#deleteHaloFromBlock -allBlock
saveDesign "${top_level}.routed2.enc"

addIoFiller -cell PFILLER20 -prefix PAD_FILLER -side e
addIoFiller -cell PFILLER10  -prefix PAD_FILLER -side e
addIoFiller -cell PFILLER1      -prefix PAD_FILLER -side e
addIoFiller -cell PFILLER05    -prefix PAD_FILLER -side e

###################################################
# Report and Output
###################################################
#stooopp


# Run some basic checks. We still have to run these with Calibre.
clearDrc
verifyGeometry -reportAllCells -viaOverlap -report ${top_level}.geom.rpt
fixMinCutVia
fillNotch
verifyGeometry -reportAllCells -viaOverlap -report ${top_level}.geom.rpt

verifyConnectivity -type all -noAntenna -report ${top_level}.conn.rpt
reportPower

# Run Geometry and Connection checks
setAnalysisMode -skew -noWarn -hold
report_timing
setAnalysisMode -skew -noWarn -setup -clockPropagation forcedIdeal
report_timing
saveDesign "${top_level}.final.enc"

# Generate SDF
setExtractRCMode -detail -relative_c_th 0.01 -total_c_th 0.01 -specialNet
extractRC -outfile ${top_level}.cap
rcOut -spf ${top_level}.spf
rcOut -spef ${top_level}.spef
setUseDefaultDelayLimit 10000
delayCal -sdf ${top_level}.apr.sdf
reportClockTree -postRoute -macromodel report_postroute.ctsmdl
#Generate SDF
#setExtractRCMode -engine detail -coupling_c_th 0 -coupled true
#extractRC
report_timing
#saveDesign "${top_level}.final_filled.enc"


# Output DEF
set dbgLefDefOutVersion 5.5
defOut -floorplan -netlist -routing ${top_level}.apr.def
    
# Output LEF
lefout "$top_level.lef" -stripePin -PGpinLayers 1 2 3 4 5 6 7 8 9 

# Output GDSII
#setStreamOutMode -snapToMGrid true -virtualConnection false
streamOut $top_level.gds -mapFile ../TSMC65.mapOut
#-libName ${top_level} -structureName $top_level -mode ALL 

# Output Netist
saveNetlist -excludeLeafCell ${top_level}.apr.v
saveNetlist -excludeLeafCell -lineLength 10000000 -includePowerGround -includePhysicalInst ${top_level}.apr.physical.v
saveNetlist -excludeLeafCell -lineLength 10000000 -includePowerGround -includePhysicalCell { FILLCAPTIE8A10TR FILLCAPTIE16A10TR FILLCAPTIE32A10TR FILLCAPTIE64A10TR FILLCAPTIE128A10TR} ${top_level}.apr.incPG.v

# Generate .lib
do_extract_model ${top_level}.lib

# Convert .lib to .db
#dc_shell
#read_lib descriptor.lib 
#write_lib descriptor -f db -output descriptor.db
#quit
#exec ../../bin/lib_to_db.sh ${top_level}

puts "**************************************"
puts "*                                    *"
puts "* Encounter script finished          *"
puts "*                                    *"
puts "**************************************"

# Add this to the end so it doesn't exit
#foobarbaz

#exit
