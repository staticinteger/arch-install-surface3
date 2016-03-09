# Format the file systems
mkfs.fat -F32 /dev/mmcblk0p1
mkfs.ext4 /dev/mmcblk0p2
mkswap /dev/mmcblk0p3
swapon /dev/mmcblk0p3
mkfs.ext4 /dev/mmcblk0p4

# Mount / create directories and mount
mount /dev/mmcblk0p2 /mnt
mkdir -p /mnt/boot
mkdir -p /mnt/home

mount /dev/mmcblk0p1 /mnt/boot
mount /dev/mmcblk0p4 /mnt/home
