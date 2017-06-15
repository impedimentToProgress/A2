//////////////////////////////////////////////////////////////////////
////                                                              ////
//// orpsoc-defines                                               ////
////                                                              ////
//// Top level ORPSoC defines file                                ////
////                                                              ////
//// Included in toplevel and testbench                           ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2009, 2010 Authors and OPENCORES.ORG           ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//
// Uncomment a `define BOARD_XYZ to configure design RTL for it.
//
// Mainly presets are for internal frequency settings, and what
// external oscillator is expected (ordb1's were made with various
// XTALs.)
//
//////////////////////////////////////////////////////////////////////

 `define XILINX
 `define XILINX_PLL
 `define FPGA_BOARD_XILINX_ML501
 `define IOCONFIG_XILINX_ML501
// `define BOARD_CLOCK_PERIOD 5000 // 200MHz (pS accuracy for Xilinx sims.) 
 `define BOARD_CLOCK_PERIOD 10 // 100MHz (nS) 

// `define ADV_DEBUG	 
// `define JTAG_DEBUG
// `define ROM_WB
 `define RAM_WB
 `define UART0
// `define GPIO0

// end of included module defines - keep this comment line here, scripts depend on it!!


//
// Arbiter defines
//

// Uncomment to register things through arbiter (hopefully quicker design)
// Instruction bus arbiter
//`define ARBITER_IBUS_REGISTERING
`define ARBITER_IBUS_WATCHDOG
// Watchdog timeout: 2^(ARBITER_IBUS_WATCHDOG_TIMER_WIDTH+1) cycles
// This has to be kind of long, as DDR2 initialisation can take a little while
// and after reset, and if this is too short we'll always get bus error.
`define ARBITER_IBUS_WATCHDOG_TIMER_WIDTH 6

// Data bus arbiter

//`define ARBITER_DBUS_REGISTERING
`define ARBITER_DBUS_WATCHDOG
// Watchdog timeout: 2^(ARBITER_DBUS_WATCHDOG_TIMER_WIDTH+1) cycles
`define ARBITER_DBUS_WATCHDOG_TIMER_WIDTH 6

// Byte bus (peripheral bus) arbiter
// Don't really need the watchdog here - the databus will pick it up
//`define ARBITER_BYTEBUS_WATCHDOG
// Watchdog timeout: 2^(ARBITER_BYTEBUS_WATCHDOG_TIMER_WIDTH+1) cycles
`define ARBITER_BYTEBUS_WATCHDOG_TIMER_WIDTH 9

