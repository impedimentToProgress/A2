# A2

For simulation (using ModelSim):
Comment-out debug options in fpga_hardware\cores\top\orpsoc-defines.v
For example, you should have
// `define ADV_DEBUG	 
// `define JTAG_DEBUG

Then make sure the clock generator is the simple one required for simulation (without needing vendor-specific libraries), see fpga_hardware\cores\clkgen\

Open ModelSim
Load a2.mpf
Compile all project files (may need to add a 'work' library)
Close ModelSim
sh runVSIM.sh
then type 'run -all' to start simulation
The simulation will create a compressed VCD file in the same directory it is run from (e.g., a2.vcd.gz)
To edit what signals the VCD tracks or the name of the VCD file edit fpga_hardware\cores\bench\orpsoc_testbench.v

This runs simulation from the command line, but it is also possible to run the simulation from inside ModelSim's GUI.

For building an FPGA bitstream (using Xilinx ISE):
Select (via uncommenting) the appropriate debug option in fpga_hardware\cores\top\orpsoc-defines.v

Then make sure the clock generator is the more complex one that takes advantage of FPGA primitives, see fpga_hardware\cores\clkgen\

make all
