UTILS = ../hardware/software/utils
GCC = or1k-elf
BOARD = ml509SRAM

all: idle math_user

idle: idle.c Makefile
	$(GCC)-gcc -Wall -mboard=$(BOARD) -Os -mhard-div -mhard-mul -o idle.or32 idle.c -Wl,--wrap,__uart_init
	$(GCC)-objdump -d idle.or32 > idle.s 
	$(GCC)-objcopy -O binary idle.or32 idle.bin 
	$(UTILS)/bin2vmem idle.bin > idle.vmem
	rm -f idle.bin

math_user: math_user.c Makefile
	$(GCC)-gcc -Wall -mboard=$(BOARD) -Os -mhard-div -mhard-mul -o math_user.or32 math_user.c -Wl,--wrap,__uart_init
	$(GCC)-objdump -d math_user.or32 > math_user.s 
	$(GCC)-objcopy -O binary math_user.or32 math_user.bin 
	$(UTILS)/bin2vmem math_user.bin > math_user.vmem
	rm -f math_user.bin

clean:
	rm -f *.or32
	rm -f *.s
	rm -f *.vmem
	rm -f *~
