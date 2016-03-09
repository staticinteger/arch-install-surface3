#!/bin/bash

echo "Updating system time..."
sh ./parts/time.sh

echo "Partitioning hard drive..."
sh ./parts/partition.sh

echo "Formatting the new partitions..."
sh ./parts/format-mount.sh

echo "Configuring mirrors (This will take a while)..."
sh ./parts/mirrors.sh

echo "Installing base packages and performing fstab..."
sh ./parts/install.sh

echo "Running chroot script..."
arch-chroot /mnt /bin/bash -c "./parts/chroot.sh"

echo "Finishing up..."
sh ./parts/finish.sh
