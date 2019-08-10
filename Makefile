FILE ?= blink

all:
	avr-gcc -mmcu=atmega328p $(FILE).s -o $(FILE).elf -nostdlib
	avr-objcopy -j .text -j .data -O ihex $(FILE).elf $(FILE).hex
	avr-objdump -h -S $(FILE).elf > $(FILE).lst

flash:
	sudo avrdude -V -p atmega328p -c arduino -b 115200 -P /dev/ttyACM0 -U flash:w:$(FILE).hex:i

clean:
	rm -f *.hex *.elf *.lst
