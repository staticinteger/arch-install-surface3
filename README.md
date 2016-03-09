# arch-install-surface3
The commands I use to install arch linux on my Surface (not pro) 3


## Getting started

#### connect to wifi & update the system clock

```
wifi-menu
timedatectl set-ntp true
```

## Partition the hard drive

#### Verify your hard drive is there and look at existing partitions

```
lsblk
parted /dev/mmcblk0 print
```

If you have any existing partitions that you don't need, you can remove them like this.

```
parted /dev/mmcblk0 rm [partition #]
```

#### Make the EFI partition and set the boot flag

```
parted /dev/mmcblk0 mkpart ESP fat32 1MiB 513MiB
parted /dev/mmcblk0 set 1 boot on
```

#### Make our root, swap, and home partitions

```
parted /dev/mmcblk0 mkpart primary ext4 513MiB 20.5GiB
parted /dev/mmcblk0 mkpart primary linux-swap 20.5GiB 24.5GiB
parted /dev/mmcblk0 mkpart primary ext4 24.5GiB 100%
```

#### Set the names on our partitions (If you made them in order)

```
parted /dev/mmcblk0 name 1 efi-boot
parted /dev/mmcblk0 name 2 root
parted /dev/mmcblk0 name 3 swap
parted /dev/mmcblk0 name 4 home
```

## Format the fyle systems and enable swap

#### Format the file systms (If you made them in order)

```
mkfs.fat -F32 /dev/mmcblk0p1
mkfs.ext4 /dev/mmcblk0p2
mkswap /dev/mmcblk0p3
swapon /dev/mmcblk0p3
mkfs.ext4 /dev/mmcblk0p4
```

## Mount our partitions ###

```
mount /dev/mmcblk0p2 /mnt
mkdir -p /mnt/boot
mkdir -p /mnt/home

mount /dev/mmcblk0p1 /mnt/boot
mount /dev/mmcblk0p4 /mnt/home
```

## Configure Mirrors ###

```
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
pacman -Syyu
```

## Install base packages and fstab

```
pacstrap -i /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab
```

## Change root and configure

```
arch-chroot /mnt /bin/bash
```

#### Set language

```
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

## Set Time

```
tzselect # Not required
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc --utc
```

## Setup Bootloader

```
mkinitcpio -p linux
bootctl install

uuid=`blkid -s PARTUUID -o value /dev/mmcblk0p2`

echo "title Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
#echo "options root=PARTUUID=$uuid rw" >> /boot/loader/entries/arch.conf
echo "options root=/dev/mmcblk0p2 rw" >> /boot/loader/entries/arch.conf

echo "default arch" > /boot/loader/loader.conf
echo "timeout 5" >> /boot/loader/loader.conf
echo "editor 0" >> /boot/loader/loader.conf
```

## Configure Network

```
echo "surnix" >> /etc/hostname
pacman -S iw wpa_supplicant dialog
```

## change root password, unmount, and reboot

```
passwd
exit
umount -R /mnt
reboot
```
