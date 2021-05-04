#This makefile automates the process of simulating a verilog module.
#To use this makefile, open the terminal and go to the location where the makefile is saved.
#Then type "make create" to compile .v files within the makefile.
#Then type "make simulate" to open the dumpfile in a simulator like GTKWave.
#If you wish to delete the .bin file created during compilation, then type "make clean".
#Remember to change the 'SOURCE_FILES' and 'DUMPFILES' to simulate a new module.

CC=iverilog
FLAGS=-Wall -Winfloop
SOURCE_FILES= ../Testbenches/seq_8_test.v ../Design/seq_8.v
DUMPFILES=../Dumpfiles/seq_8_test.vcd

create:
	${CC} ${FLAGS} -o output.bin ${SOURCE_FILES}
	vvp output.bin
simulate:
	gtkwave ${DUMPFILES}
clean:
	rm -f *.bin
