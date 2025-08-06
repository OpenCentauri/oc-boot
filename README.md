# Open-source bootloader for the Centauri Carbon mainboard / Allwinner R528 SoC

This repository contains an open-source bootloader for the Centauri Carbon mainboard, which uses the Allwinner R528 SoC.

## Prerequisites

Before you begin, ensure you have the following prerequisites installed and configured:

*   **GCC ARM Toolchain:** You'll need the `gcc-arm-none-eabi` package to cross-compile for the ARM architecture.
*   **sunxi-tools:** This collection of tools is essential for working with Allwinner SoCs. It includes `sunxi-fel`, which is used to communicate with the device in FEL mode.
*   **Serial Interface:** A serial interface connected to UART0 on the Centauri Carbon mainboard is required for debugging and communication.
*   **FEL USB Connection:** You'll need to connect your computer to the USB-C hotend port on the mainboard. **EXTREME CAUTION: Ensure that the 24V VCC is NOT mated, as this can be dangerous.**

On a Debian or Ubuntu-based system, you can install the required packages with the following command:

```bash
sudo apt install gcc-arm-none-eabi sunxi-tools
```

## Getting Started

1.  **Build:** To build the `hello world` example and the `cc-boot` bootloader, run the following command:

    ```bash
    make
    ```

2.  **Flash "Hello World":** To flash the `hello world` example to the device, use the following command. This will use `sunxi-fel` to flash the application.

    ```bash
    make flash-hello
    ```

3.  **Flash Bootloader:** To flash the bootloader, use the following command. Please note that the bootloader is currently under development and does not yet have full bootloader functionality.

    ```bash
    make flash-boot
    ```

## Resources

*   **[FEL - linux-sunxi.org](https://linux-sunxi.org/FEL):** An excellent resource for understanding the FEL mode on Allwinner devices. FEL is a low-level subroutine in the BootROM used for initial programming and recovery via USB.
*   **[linux-sunxi/sunxi-tools](https://github.com/linux-sunxi/sunxi-tools):** The official repository for the `sunxi-tools` command-line utilities.
*   **[awboot](https://github.com/szemzoa/awboot):** A related bootloader project that has served as a reference.
*   **[U-Boot Patch for Allwinner R528](https://lists.denx.de/pipermail/u-boot/2023-January/503315.html):** A U-Boot mailing list thread discussing the addition of DRAM initialization for the R528 SoC, which is relevant to this project.
*   **[100ask-t113-pro eLinuxCore SDK](https://github.com/DongshanPI/eLinuxCore_100ask-t113-pro.git):** The T113 Pro SDK, which is for a very similar and binary-compatible Allwinner chipset to the R528. This is a valuable reference for hardware and bootloader specifics.

## License

This project is licensed under the GNU General Public License v2.0. See the `LICENSE.md` file for more details.
