## Trigger Program

We implement several triggers as a part of A2. To select which trigger
you want to use, go to **math_user.c** and comment/uncomment the
appropriate lines in **main()**. There are two versions of most trigger
code sequences: inline assembly and pure C.

## Idle Program

Just a simple empty loop to show the background toggle rate of the
processor's wires.

## Building

**make all** builds both idle and trigger binaries
**make idle** builds the idle binary
**make math_user** builds the trigger binary
**make clean** removes all files that building produces

# Creating a Toggle Video

Requires: You will need to simulate the processor and pass the
resulting VCD file to a program that divides the simulation time into
bins and reports the toggle rate for each wire in the VCD for each
time bin. Fortunately, I wrote an example program that does this as
part of my VCD processing library:
https://github.com/impedimentToProgress/ProcessVCD.

To create a histogram for a single bin, see **histogram.gp** in this repo.

To create a video for all bins, run **makeHists.sh** in this repo.
