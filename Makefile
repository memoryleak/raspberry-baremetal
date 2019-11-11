# Specify the compiler and assembler options.
COMPFLAGS = -g -c -O1 -Wall
ASMFLAGS = --gstabs

# The object files are specific to this program.
OBJECTS = blinkLED.o gpioPinFSelect.o gpioPinSet.o gpioPinClr.o

blinkLED: $(OBJECTS)
	gcc -o build/blinkLED build/blinkLED.o build/gpioPinFSelect.o build/gpioPinSet.o build/gpioPinClr.o

blinkLED.o: gpioPinFSelect.o gpioPinSet.o gpioPinClr.o
	gcc $(COMPFLAGS) -o build/blinkLED.o src/blinkLED.s

gpioPinFSelect.o: src/gpioPinFSelect.s
	as $(ASMFLAGS) -o build/gpioPinFSelect.o src/gpioPinFSelect.s

gpioPinSet.o: src/gpioPinSet.s
	as $(ASMFLAGS) -o build/gpioPinSet.o src/gpioPinSet.s

gpioPinClr.o: src/gpioPinClr.s
	as $(ASMFLAGS) -o build/gpioPinClr.o src/gpioPinClr.s


clean:
	rm build/*
