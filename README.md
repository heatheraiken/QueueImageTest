# QueueImageTest

Hello, I'm trying to use PTB with VPixx to draw 12 frames at 1440Hz  using the automatic frame assignment (with QueueImage). 
I expect the drawing of the frames to take place in less than 0.0083s. When measuring the timings with fill oval, the timings 
worked as expected. However, when measuring the timings with draw texture (what I need to run my experiment), the  timings of 
every 12th QueueImage take about 0.03s. This is about 4 times slower than it should be. The images I am drawing are small 
(3 images of about 40KB each), and when I draw just one of these, the timings are  still 4 times slower. It seems like the 
hardware is okay because fill  oval works as expected, but I'm not sure why draw texture does not.

PsychtoolboxVersion:  '3.0.18 - Flavor: beta - Corresponds to SVN Revision 13005

I am doing this on a Mac Mini running Linux

Hardware versions: 
H/W path           Device     Class          Description
========================================================
                              system         Macmini7,1 (System SKU#)
/0                            bus            Mac-35C5E08120C7EEAF
/0/0                          processor      Intel(R) Core(TM) i5-4308U CPU @ 2.
/0/0/2                        memory         64KiB L1 cache
/0/0/3                        memory         512KiB L2 cache
/0/0/4                        memory         3MiB L3 cache
/0/1                          memory         64KiB L1 cache
/0/5                          memory         8GiB System Memory
/0/5/0                        memory         4GiB SODIMM DDR3 Synchronous 1600 M
/0/5/1                        memory         4GiB SODIMM DDR3 Synchronous 1600 M
/0/b                          memory         1MiB BIOS
/0/2fdd                       memory         1019KiB BIOS
/0/100                        bridge         Haswell-ULT DRAM Controller
/0/100/2                      display        Haswell-ULT Integrated Graphics Con
/0/100/3                      multimedia     Haswell-ULT HD Audio Controller
/0/100/14                     bus            8 Series USB xHCI HC
/0/100/14/0        usb1       bus            xHCI Host Controller
/0/100/14/0/1                 bus            Mini DisplayPort to Dual-Link DVI A
/0/100/14/0/2                 generic        PROPixx
/0/100/14/0/3                 bus            BRCM20702 Hub
/0/100/14/0/3/3               communication  Bluetooth USB Host Controller
/0/100/14/0/4                 input          IR Receiver
/0/100/14/0/7                 bus            USB2.0 Hub
/0/100/14/0/7/2               input          DELL USB Keyboard
/0/100/14/0/7/3               generic        PROPixxCtrl
/0/100/14/0/7/4               input          USB Optical Mouse
/0/100/14/1        usb2       bus            xHCI Host Controller
/0/100/14/1/3                 bus            USB3.0 Hub
/0/100/16                     communication  8 Series HECI #0
/0/100/1b                     multimedia     8 Series HD Audio Controller
/0/100/1c                     bridge         8 Series PCI Express Root Port 1
/0/100/1c.2                   bridge         8 Series PCI Express Root Port 3
/0/100/1c.2/0      wlp2s0     network        BCM4360 802.11ac Wireless Network A
/0/100/1c.3                   bridge         8 Series PCI Express Root Port 4
/0/100/1c.3/0      enp3s0f0   network        NetXtreme BCM57766 Gigabit Ethernet
/0/100/1c.3/0.1               generic        BCM57765/57785 SDXC/MMC Card Reader
/0/100/1c.4                   bridge         8 Series PCI Express Root Port 5
/0/100/1c.4/0                 bridge         DSL5520 Thunderbolt 2 Bridge [Falco
/0/100/1c.4/0/0               bridge         DSL5520 Thunderbolt 2 Bridge [Falco
/0/100/1c.4/0/0/0             generic        DSL5520 Thunderbolt 2 NHI [Falcon R
/0/100/1c.4/0/3               bridge         DSL5520 Thunderbolt 2 Bridge [Falco
/0/100/1c.4/0/4               bridge         DSL5520 Thunderbolt 2 Bridge [Falco
/0/100/1c.4/0/5               bridge         DSL5520 Thunderbolt 2 Bridge [Falco
/0/100/1c.4/0/6               bridge         DSL5520 Thunderbolt 2 Bridge [Falco
/0/100/1c.5                   bridge         8 Series PCI Express Root Port 6
/0/100/1c.5/0                 storage        Samsung Electronics Co Ltd
/0/100/1f                     bridge         8 Series LPC Controller
/0/100/1f.3                   bus            8 Series SMBus Controller
/0/2                          system         PnP device PNP0103
/0/3                          system         PnP device PNP0c02
/0/4                          system         PnP device PNP0b00
/0/6                          system         PnP device PNP0c02
/0/7                          system         PnP device PNP0c01
/0/8               scsi0      storage        
/0/8/0.0.0         /dev/sda   disk           251GB APPLE SSD SM0256
/0/8/0.0.0/1                  volume         200MiB EFI GPT partition
/0/8/0.0.0/2       /dev/sda2  volume         135GiB Darwin/OS X HFS+ partition
/0/8/0.0.0/3       /dev/sda3  volume         619MiB Darwin/OS X HFS+ partition
/0/8/0.0.0/4       /dev/sda4  volume         11GiB Linux swap volume
