# Install the base packages
pacstrap -i /mnt base base-devel

# Perform fstab (Poor Hard Drive <3)
genfstab -U /mnt >> /mnt/etc/fstab
