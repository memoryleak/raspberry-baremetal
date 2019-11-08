###############################################################################
#    makefile
#     by Alex Chadwick
#
#    A makefile script for generation of raspberry pi kernel images.
###############################################################################

# The toolchain to use. arm-none-eabi works, but there does exist
# arm-bcm2708-linux-gnueabi.
ARMGNU ?= arm-none-eabi

# The intermediate directory for compiled object files.
BUILD = build/

# The directory in which source files are stored.
SOURCE = src/

DIST = dist/

# The name of the output file to generate.
TARGET = dist/kernel.img

# The name of the assembler listing file to generate.
LIST = build/kernel.list

# The name of the map file to generate.
MAP = build/kernel.map

# The name of the linker script to use.
LINKER = src/kernel.ld

# The names of all object files that must be generated. Deduced from the
# assembly code files in source.
OBJECTS := $(patsubst $(SOURCE)%.s,$(BUILD)%.o,$(wildcard $(SOURCE)*.s))

# Rule to make everything.
all: $(TARGET) $(LIST) blobs

# Rule to remake everything. Does not include clean.
rebuild: all 

# Rule to make the listing file.
$(LIST) : $(BUILD)output.elf
	$(ARMGNU)-objdump -d $(BUILD)output.elf > $(LIST)

# Rule to make the image file.
$(TARGET) : $(BUILD)output.elf
	$(ARMGNU)-objcopy $(BUILD)output.elf -O binary $(TARGET)

# Rule to make the elf file.
$(BUILD)output.elf : $(OBJECTS) $(LINKER)
	$(ARMGNU)-ld --no-undefined $(OBJECTS) -Map $(MAP) -o $(BUILD)output.elf -T $(LINKER)

# Rule to make the object files.
$(BUILD)%.o: $(SOURCE)%.s $(BUILD)
	$(ARMGNU)-as -I $(SOURCE) $< -o $@

$(BUILD):
	mkdir $@

blobs:
	cp blob/bootcode.bin $(DIST)
	cp blob/fixup.dat $(DIST)
	cp blob/start.elf $(DIST)

# Rule to clean files.
clean :
	-rm -rf "$(BUILD)*"
	-rm -rf "$(DIST)*"