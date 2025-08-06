# Copyright (C) 2012       Alejandro Mery <amery@geeks.cl>
# Copyright (C) 2012,2013  Henrik Nordstrom <henrik@henriknordstrom.net>
# Copyright (C) 2013       Patrick Wood <patrickhwood@gmail.com>
# Copyright (C) 2013       Pat Wood <Pat.Wood@efi.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Windows predefines OS in the environment (to "Windows_NT"), otherwise use uname
OS ?= $(shell uname)

CC ?= gcc

# ARM binaries and images
# Note: To use this target, set/adjust CROSS_COMPILE and MKSUNXIBOOT if needed
BINFILES = oc-boot.sunxi hello.sunxi
MKSUNXIBOOT ?= mksunxiboot

CROSS_DEFAULT := arm-none-eabi-
CROSS_COMPILE ?= $(or $(shell ./find-arm-gcc.sh),$(CROSS_DEFAULT))
CROSS_CC := $(CROSS_COMPILE)gcc

.PHONY: all clean

all: binfiles

binfiles: $(BINFILES)

flash-boot: oc-boot.sunxi
	sunxi-fel -v -p spl oc-boot.sunxi

flash-hello: hello.sunxi
	sunxi-fel -v -p spl hello.sunxi

#@rm -vf $(TOOLS) $(FEXC_LINKS) $(TARGET_TOOLS) $(MISC_TOOLS)
clean:
	@rm -vf version.h *.o *.elf *.sunxi *.bin *.nm *.orig

sunxi-%: %.c
	$(CC) $(HOST_CFLAGS) $(LDFLAGS) -o $@ $(filter %.c,$^) $(LIBS)

%.bin: %.elf
	$(CROSS_COMPILE)objcopy -O binary $< $@

%.sunxi: %.bin
	$(MKSUNXIBOOT) $< $@

ARM_ELF_FLAGS = -Os -marm -fpic -Wall
ARM_ELF_FLAGS += -fno-common -fno-builtin -ffreestanding -nostdinc -fno-strict-aliasing
ARM_ELF_FLAGS += -mno-thumb-interwork -fno-stack-protector -fno-toplevel-reorder
ARM_ELF_FLAGS += -Wstrict-prototypes -Wno-format-nonliteral -Wno-format-security

oc-boot.elf: oc-boot.c oc-boot.lds version.h
	$(CROSS_CC) -march=armv5te -g $(ARM_ELF_FLAGS) $< -nostdlib -o $@ -T oc-boot.lds -Wl,-N

hello.elf: hello.c hello.lds version.h
	$(CROSS_CC) -march=armv5te -g $(ARM_ELF_FLAGS) $< -nostdlib -o $@ -T hello.lds -Wl,-N

version.h:
	@./autoversion.sh > $@

