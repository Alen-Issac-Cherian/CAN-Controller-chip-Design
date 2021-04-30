#This makefile automates the process of simulating a verilog module.
#Remember to change the 'SOURCE_FILES' and 'DUMPFILES' to simulate a new module.

CC=iverilog
FLAGS=-Wall -Winfloop
SOURCE_FILES= ../Testbenches/CRC_tb.v ../Design/CRC.v
DUMPFILES=../Dumpfiles/CRC_tb.vcd

create:
	${CC} ${FLAGS} -o output.bin ${SOURCE_FILES}
	vvp output.bin
simulate:
	gtkwave ${DUMPFILES}
clean:
	rm -f *.bin
