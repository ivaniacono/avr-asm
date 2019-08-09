all:
	avr-gcc -mmcu=atmega328p main.s -o main.elf -nostdlib
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	avr-objdump -h -S main.elf > main.lst

flash:
	sudo avrdude -V -p atmega328p -c arduino -b 115200 -P /dev/ttyACM0 -U flash:w:main.hex:i

clean:
	rm -f *.hex *.elf *.lst
