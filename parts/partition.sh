# Make EFI Partition
parted /dev/mmcblk0 mkpart ESP fat32 1MiB 513MiB
parted /dev/mmcblk0 set 1 boot on

# Make root, swap, and home partition
parted /dev/mmcblk0 mkpart primary ext4 513MiB 20.5GiB
parted /dev/mmcblk0 mkpart primary linux-swap 20.5GiB 24.5GiB
parted /dev/mmcblk0 mkpart primary ext4 24.5GiB 100%

# Name the partitions
parted /dev/mmcblk0 name 1 efi-boot
parted /dev/mmcblk0 name 2 root
parted /dev/mmcblk0 name 3 swap
parted /dev/mmcblk0 name 4 home
