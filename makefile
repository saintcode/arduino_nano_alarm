#on board device atmega328
DEVICE = atmega328p

#20MHz
CLOCK = 20000000

#run avrdude. config from Arduino IDE.
AVRDUDE = C:\arduino-nightly\hardware\tools\avr/bin/avrdude -CC:\arduino-nightly\hardware\tools\avr/etc/avrdude.conf -v -patmega328p -carduino -PCOM4 -b57600 -D

OBJECTS = main.o

COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

all:	main.hex

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@

.c.s:
	$(COMPILE) -S $< -o $@

flash:	all
	$(AVRDUDE) -U flash:w:main.hex:i

clean:
	rm -f main.hex main.elf $(OBJECTS)

main.elf: $(OBJECTS)
	$(COMPILE) -o main.elf $(OBJECTS)

main.hex: main.elf
	rm -f main.hex
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	avr-size --format=avr --mcu=$(DEVICE) main.elf
