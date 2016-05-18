FILE2 = bmhasrch.c  bmhisrch.c  bmhsrch.c  pbmsrch_large.c 

all: search_large

search_large: ${FILE2} Makefile ../*.h
	or32-elf-gcc -DBARE_METAL -mboard=ml509 ${FILE2} -Os -o search_large -lnosys -lc
	or32-elf-objdump -d search_large > search.S
	or32-elf-objcopy -O binary search_large search.bin
	../../utils/bin2vmem search.bin > search.vmem
	rm -f *.bin

clean:
	rm -rf search_large output* *.vmem *.S *~
