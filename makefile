# Makefile for compiling pure assembly projects for the Raspberry Pi Pico (RP2040)

CC=arm-none-eabi-gcc
MACH=cortex-m0plus
CFLAGS= -c -mcpu=$(MACH) -mthumb -std=gnu11 -Wall -O0 
LFLAGS= -nostdlib -T ls.ld -Wl,-Map=final.map

# Use wildcard to find all .s files in src/ and subdirectories
SRC_DIR=../src
ASM_FILES=$(wildcard $(SRC_DIR)/**/*.s $(SRC_DIR)/*.s)
OBJ_FILES=$(ASM_FILES:.s=.o)

all: bs2_default_padded_checksummed.o vector_table.o $(OBJ_FILES)

# Pattern rule to compile all .s files to .o
%.o: %.s
	$(CC) $(CFLAGS) -o $@ $^

bs2_default_padded_checksummed.o: bs2_default_padded_checksummed.S	
	$(CC) $(CFLAGS) -o $@ $^

vector_table.o: vector_table.S
	$(CC) $(CFLAGS) -o $@ $^

final.elf: bs2_default_padded_checksummed.o vector_table.o $(OBJ_FILES)
	$(CC) $(LFLAGS) -o $@ $^

clean:
	rm -rf $(wildcard *.o)  
	rm -rf $(wildcard *.elf) 
	rm -rf $(wildcard *.uf2)
	rm -rf $(wildcard *.map)
	
link: final.elf

uf2: 
	./elf2uf2 final.elf final.uf2
