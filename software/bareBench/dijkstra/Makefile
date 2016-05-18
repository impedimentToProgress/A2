all:  dijkstra_large

dijkstra_large: dijkstra_large.c Makefile
	or32-elf-gcc -mboard=ml509 -Os -DBARE_METAL dijkstra_large.c -o dijkstra_large -lnosys -lc
	or32-elf-objdump -d dijkstra_large > dijkstra.S
	or32-elf-objcopy -O binary dijkstra_large dijkstra.bin
	../../utils/bin2vmem dijkstra.bin > dijkstra.vmem
	rm -f *.bin
clean:
	rm -rf dijkstra_large dijkstra_small output* *.vmem *.S *~
