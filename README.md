Open-source bootloader for the Centauri Carbon mainboard / Allwinner R528 SoC.

Prerequisites: (assuming Debian or Ubuntu):
* sudo apt install gcc-arm-none-eabi sunxi-tools
* Serial interface connected to UART0 on CC mainboard
* FEL USB connected to USB-C hotend port (without VCC mated, 24V DANGER!!!) or unpinned header

How to use:
make (builds hello world example and cc-boot bootloader, which is mostly just hello world for right now)
make flash-hello (this flashes hello world example via sunxi-fel)
make flash-boot (this flashes the bootloader via sunxi-fel, which doesn't do bootloader stuff yet!)

Resources:
* https://linux-sunxi.org/FEL
* https://github.com/linux-sunxi/sunxi-tools/
* https://github.com/szemzoa/awboot/
* https://lists.denx.de/pipermail/u-boot/2023-January/503315.html
