# Set lanugage
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set Time
tzselect # Not required
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc --utc

#Setup bootloader
mkinitcpio -p linux
bootctl install

# Setup the bootloader config
uuid=`blkid -s PARTUUID -o value /dev/mmcblk0p2`

echo "title Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
#echo "options root=PARTUUID=$uuid rw" >> /boot/loader/entries/arch.conf
echo "options root=/dev/mmcblk0p2 rw" >> /boot/loader/entries/arch.conf

echo "default arch" > /boot/loader/loader.conf
echo "timeout 5" >> /boot/loader/loader.conf
echo "editor 0" >> /boot/loader/loader.conf

# Configure Network
echo "surnix" >> /etc/hostname
pacman -S iw wpa_supplicant dialog

# Set root password and exit chroot
passwd
exit
