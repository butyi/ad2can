# ad2can

Measured analogue voltage sending to CAN

## Motivation

I had a claim investigation where I needed evidence about a power supply
connector has no contact issue or any interuption when problem occures.

## Hardware

As usual I used
[sci2can](https://github.com/butyi/sci2can),
my small UART to CAN converter board again.
I have extended the board with three additional analogue input.
These are connected to PTA2, PTA3 and PTA4.

![board top](https://github.com/butyi/ad2can/blob/main/board_top.jpg)
![board bottom](https://github.com/butyi/ad2can/blob/main/board_bottom.jpg)

With this change circuit can measure five voltages
and additionally the board supply battery voltage on PTA5.

Each inputs has voltage divider by 10k Ohm-1kOhm.
1kOhm is the measured voltage, it has parallel 5V
transient supressor and 1uF capacitor.

## Software

10ms periodic interrupt provided by RTC module.
This event sends the values on CAN.
During 10ms is spending, the background task measures each six channels,
about 200 times and saves the minimum and maximum values of measured samples.
CAN messages contain these minimum and maximum values to be reported any
voltage change even shorter than 10ms.
Since 200 measuring happen in 10ms, shortest detected pulse is 50ns.

Software is pure, does not require underlayer bootloader.

## Compile

- Download assembler from [aspisys.com](http://www.aspisys.com/asm8.htm).
  It works on both Linux and Windows.
- Check out the repo
- Run `asm8 prg.asm` on Linux, or `asm8.exe prg.asm` on Windows.
- prg.s19 is now ready to download.

## Download

I have used the cheap USBDM Hardware interface. I have bought it for 10€ on Ebay.
Just search "USBDM S08".

USBDM has free software tool support for S08 microcontrollers.
You can download it from [here](https://sourceforge.net/projects/usbdm/).
When you install the package, you will have Flash Downloader tools for several
target controllers. Once is for S08 family.

## License

This is free. You can do anything you want with it.
While I am using Linux, I got so many support from free projects,
I am happy if I can give something back to the community.

## Keywords

Analogue, measurement, CAN,
Motorola, Freescale, NXP, MC68HC9S08DZ60, 68HC9S08DZ60, HC9S08DZ60, MC9S08DZ60,
9S08DZ60, HC9S08DZ48, HC9S08DZ32, HC9S08DZ, 9S08DZ.

###### 2024 Janos BENCSIK

