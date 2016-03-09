# Configure our mirrors
curl -o /etc/pacman.d/mirrorlist.backup "https://www.archlinux.org/mirrorlist/?country=US"
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
pacman -Syyu
