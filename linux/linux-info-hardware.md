title: linux硬件信息
date: 2016-01-31 16:41:56
tags: Linux
categories: Linux
---
在LINUX环境开发驱动程序，首先要探测到新硬件，接下来就是开发驱动程序。
常用命令整理如下
```bash
用硬件检测程序kuduz探测新硬件：service kudzu start ( or restart)
查看CPU信息：cat /proc/cpuinfo
查看板卡信息：cat /proc/pci
查看PCI信息：lspci (相比cat /proc/pci更直观）
查看内存信息：cat /proc/meminfo
查看USB设备：cat /proc/bus/usb/devices
查看键盘和鼠标:cat /proc/bus/input/devices
查看系统硬盘信息和使用情况：fdisk & disk - l   & df
查看各设备的中断请求(IRQ):cat /proc/interrupts
查看系统体系结构：uname -a
dmidecode查看硬件信息，包括bios、cpu、内存等信息
dmesg | more 查看硬件信息
```
# 在Linux 系统中，对硬件判别的标识的依据
在 LinuxSir.Org 讨论区，我们经常看到有些弟兄这样来描述自己的硬件“我的显示卡是XXX牌子的，
Linux 不支持怎么办？”。其实这样描述是最差的，大家也根本没有办法提供帮助；因为Linux对硬件
的识别是以为芯片组的厂商为依据的，而非硬件的品牌；因为现 在硬件厂商大多是OEM的，也就是说
硬件的主芯片是他们生产不了的，但他们会从硬件主芯片厂商拿来，焊接在自己的电路板上，这就是
OEM 的过程；无论什么硬件都是以芯片组的厂商为标识的，而不是什么市场看到的这个品牌，那个品牌的；
举个例子，我们在市场上看到有各种各样的显卡，其实看一下他 们的芯片，大多是ATI和 NVIDIA的，
所有的ATI和NVIDIA的驱动都是ATI和NVIDIA开发出来的。所以我们提问的时候，要把硬件的芯片说出来，
芯片是驱动的唯一标 识，而不是品牌！！！所以我们要找硬件的驱动时，我们一定要根据硬件主芯片的信
息来找相关的驱动；
## lspci 列出所有PCI 设备
lspci - list all PCI devices ，主要是有来列出机器中的PCI 设备，比如声卡、显卡、猫、网卡等，
主板集成设备也能列出来；lspci 是读取 hwdata 数据库，hwdata 由软件包 hwdata 提供；大约有如下文件；
```bash
# rpm -ql hwdata-0.158-1
/etc/hotplug/blacklist
/etc/pcmcia
/etc/pcmcia/config
/usr/X11R6/lib/X11/Cards
/usr/share/doc/hwdata-0.158
/usr/share/doc/hwdata-0.158/COPYING
/usr/share/doc/hwdata-0.158/LICENSE
/usr/share/hwdata
/usr/share/hwdata/CardMonitorCombos
/usr/share/hwdata/Cards
/usr/share/hwdata/MonitorsDB
/usr/share/hwdata/pci.ids
/usr/share/hwdata/pcitable
/usr/share/hwdata/upgradelist
/usr/share/hwdata/usb.ids
```
lspci 有两个参数是我们常用的，-b 和-v ，lspci 也会把usb接口列出来
```bash
# lspci -b
00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
02:09.0 CardBus bridge: Texas Instruments Texas Instruments PCIxx21/x515 Cardbus Controller
02:09.2 FireWire (IEEE 1394): Texas Instruments Texas Instruments OHCI Compliant IEEE 1394 Host Controller
02:09.3 Unknown mass storage controller: Texas Instruments Texas Instruments PCIxx21 Integrated FlashMedia Controller
02:09.4 Class 0805: Texas Instruments Texas Instruments PCI6411, PCI6421, PCI6611, PCI6621, PCI7411, PCI7421, PCI7611, PCI7621 Secure Digital (SD)
分析一下这台机器中有什么设备，看主要的就行，与我们应用相关的；
00:02.0 VGA compatible controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02) 
00:02.1 Display controller: Intel Corporation 82852/855GM Integrated Graphics Device (rev 02)    注：这是显示卡；
USB Controller 表示的是USB 接口；我们看到有三个这样的设备；我的笔记本上正好有三个USB 接口；
Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03) 注：这是声卡；
Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 03) 注：这是猫；
Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10) 注：这是网卡，芯片是8139的；
FireWire (IEEE 1394): Texas Instruments Texas Instruments OHCI Compliant IEEE 1394 Host
```
## 存储设备查看和操作工具
查看存储设备的工具主要有 fdisk ；parted ；cfdisk 等；最常用也是最方便的就是fdisk ；
parted 就当一个补充吧，这个工具目前看来并不是太成熟
## 通过查看/proc 目录的相应文件获取一些硬件信息
我们在查看 /etc/fstab 时，会注意到这样一行；
/dev/proc               /proc                   proc    defaults        0 0
proc 看起来象是一个文件系统，其实他并不是一个真正的文件系统 ， 它是“proc - process information pseudo-filesystem”，译成中文大概的意思是“进程信息伪装文件系统”呵呵，这是我翻译的，有可能不对，请多多指正；
“The proc filesystem is a pseudo-filesystem which is used as an interface to kernel data
structures. It is commonly mounted at /proc. Most of it is read-only, but some files allow
kernel variables to be changed.”
我再来乱译一下然后再根据/proc 的内容自己理解理解。proc 文件系统做为内核kernel 数据结构的接口，把kernel 的一些信息（比如硬件信息，包括CPU 、网卡、显示卡、内存、文件系统、SCSI 设备 ....）写到 proc 文件系统中，proc被mont 到 /proc 目录；/proc 目录中有大数据大多文件是只读的，但一些数据是根据内核的变化而变化的；/proc 目录中的数据是经常变动的，对于系统中的每个进程都有一个PID；都可以在/proc 中找到；我们也可以通过 ps -aux |more 来查看进程；
我们可以通过 cat 命令来读取/proc 目录下的文件，比如cpu的信息；
[root@localhost beinan]# cat /proc/cpuinfo
详细的内容还得需要您来慢慢查看；对于 /proc 的了解也是有必要的；
## dmesg
dmesg 是一个显示内核缓冲区系统控制信息的工具；比如系统在启动时的信息会写到/var/log/
注：dmesg 工具并不是专门用来查看硬件芯片组标识的工具，但通过这个工具能让我们知道机器中的硬件的一些参数；因为系统在启动的时候，会写一些硬件相关的日志到 /var/log/message* 或 /var/log/boot* 文件中；
如果我们用这个工具来查看一些硬件的信息；这个工具信息量太大，的确需要耐心；
[root@localhost beinan]# dmesg
[root@localhost beinan]# dmesg -c 注：清理掉缓冲区，下次开机的时候还会自动生成；
## hwbrowser
hwbrowser 是 您当前硬件配置的图形化浏览器 ，这个工具是图形的。可能系统在默认的情况下没有安装。需要您安装才行。在Fedora 4.0 中，如果能用yum 或apt 应该是通过如下的命令来安装；
[root@localhost beinan]# yum install hwbrowser
或 
[root@localhost beinan]# apt install hwbrowser 
[root@localhost beinan]# hwbrowser 
当然您也可以通过rpmfind.net 或者freshrpms.net 上寻找rpm 包来安装
[root@localhost beinan]# rpm -ivh hwbrowser*.rpm 
我建议您最好是通过软件包更新工具yum 和apt来安装，这样能自动解决依赖关系；

## lshal 和 hal-device-manager
通过 lshal 和hal-device-manager 也能知道硬件相关信息，不过这个工具对新手操作起来是有点麻烦，
但我还是得介绍一下；
[root@localhost beinan]# lshal 
hwbrowser 是 lshal 的图形化界；可能系统在默认的情况下没有安装，这个工具包是Fedora 扩展包，
需要您安装才行。在Fedora 4.0 中，如果能用yum 或apt 应该是通过如下的命令来安装；
[root@localhost beinan]# yum install hal-device-manager
或 
[root@localhost beinan]# apt install hal-device-manager
[root@localhost beinan]# hal-device-manager
当然您也可以通过rpmfind.net 或者freshrpms.net 上寻找rpm 包来安装
[root@localhost beinan]# rpm -ivh hal-device-manager*.rpm 
我建议您最好是通过软件包更新工具yum 和apt来安装，这样能自动解决依赖关系；

