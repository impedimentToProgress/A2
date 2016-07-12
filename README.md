# A2

## Using simulation to determine victim wire toggle rates

Comment-out debug options in fpga_hardware\cores\top\orpsoc-defines.v
For example, you should have

`// define ADV_DEBUG`	 
`// define JTAG_DEBUG`

Then make sure the clock generator is the simple one required for simulation (without needing vendor-specific libraries), see `fpga_hardware\cores\clkgen\`

Open `ModelSim` GUI program
Open the project file `a2.mpf`
Compile all project files (may need to add a `work` library)
Close `ModelSim`
`sh runVSIM.sh`
then type `run -all` to start simulation
The simulation will create a compressed VCD file in the same directory it is run from (e.g., a2.vcd.gz)
To edit what signals the VCD tracks or the name of the VCD file edit `fpga_hardware\cores\bench\orpsoc_testbench.v`

See `A2Sim.jpg` for an example of a successful simulation. Note that the simulation will not stop on its own as the program being simulated never stops. 

This runs simulation from the command line, but it is also possible to run the simulation from inside ModelSim's GUI.

## Build an FPGA bitstream

The provided scripts assume that you are using Xilinx ISE and the path to the command line tools has been added to your system's `PATH` variable.

Select (via uncommenting) the appropriate debug option in `fpga_hardware\cores\top\orpsoc-defines.v`. If you don't know which debug option to select, you will need to read-up on the two debugging options as well as look at how I have them implemented in the source files.  The easiest path forward is to give up on debugging using JTAG and hope that your programs runs well enough to output text to the serial console :). 

Then make sure the clock generator is the more complex one that takes advantage of FPGA primitives, see `fpga_hardware\cores\clkgen\`.

`make all`

## Changing the program loaded into memory

Now that you have simulated the provided program or built and run an FPGA implementation of the default program, you may want to simulate/run your own programs.  In order to do that, you will need to write (in C or assembly), compile (using the OR1K gcc toolchain and newlib), and convert the resulting binary into a vmem file suitable for loading directly loading to memory.

Here are the basic steps of the compile and conversion process:
* Compile your program using the [OR1K toolchain](http://opencores.org/or1k/OpenRISC_GNU_tool_chain)
* Convert the resulting binary file to a bin file using `or1k-elf-objdump -O binary`
* Convert the bin file to a vmem file using the `bin2vmem` utility in `software/utils`
* Rename the resulting sram file `sram.vmem` and replace the file in `fpga_hardware/cores/ram_wb`
* If you get illegal instruction exceptions (0x700), you may need to move `sram.vmem` to `fpga_hardware/`
