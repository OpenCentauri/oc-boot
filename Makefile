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

%.bin: %.elf
	$(CROSS_COMPILE)objcopy -O binary $< $@

%.sunxi: %.bin
	$(MKSUNXIBOOT) $< $@

ARM_ELF_FLAGS = -Os -marm -fpic -Wall
ARM_ELF_FLAGS += -fno-common -fno-builtin -ffreestanding -nostdinc -fno-strict-aliasing
ARM_ELF_FLAGS += -mno-thumb-interwork -fno-stack-protector -fno-toplevel-reorder
ARM_ELF_FLAGS += -Wstrict-prototypes -Wno-format-nonliteral -Wno-format-security
ARM_ELF_FLAGS += -fno-exceptions -I. -Iarch -Imach-t113s3 -I/home/paul/sandbox/carbon/gcc-linaro-6.4.1-2017.11-x86_64_arm-linux-gnueabihf/arm-linux-gnueabihf/libc/usr/include -I/home/paul/sandbox/carbon/gcc-linaro-6.4.1-2017.11-x86_64_arm-linux-gnueabihf/lib/gcc/arm-linux-gnueabihf/6.4.1/include

ARM_LNK_FLAGS = -L/home/paul/sandbox/carbon/gcc-linaro-6.4.1-2017.11-x86_64_arm-linux-gnueabihf/arm-linux-gnueabihf/libc/usr/lib -lgcc

oc-boot.elf: oc-boot.c board.c mach-t113s3/arch_timer.c mach-t113s3/memcpy.S mach-t113s3/memset.S mach-t113s3/sunxi_gpio.c mach-t113s3/sunxi_sdhci.c mach-t113s3/sdmmc.c mach-t113s3/sunxi_usart.c mach-t113s3/sunxi_clk.c oc-boot.lds version.h
	$(CROSS_CC) -march=armv5te -g $(ARM_ELF_FLAGS) oc-boot.c board.c mach-t113s3/arch_timer.c mach-t113s3/memcpy.S mach-t113s3/memset.S mach-t113s3/sunxi_gpio.c mach-t113s3/sunxi_sdhci.c mach-t113s3/sdmmc.c mach-t113s3/sunxi_usart.c mach-t113s3/sunxi_clk.c -nostdlib -nostartfiles -o $@ -T oc-boot.lds -Wl,-N -Wl,--unresolved-symbols=ignore-all $(ARM_LNK_FLAGS)

hello.elf: hello.c hello.lds version.h
	$(CROSS_CC) -march=armv5te -g $(ARM_ELF_FLAGS) $< -nostdlib -o $@ -T hello.lds -Wl,-N $(ARM_LNK_FLAGS)

version.h:
	@./autoversion.sh > $@

