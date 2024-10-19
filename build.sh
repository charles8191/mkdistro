#!/bin/bash

set -ex

KERNEL_RELEASES_REPO="charles8191/linux-prebuilds"
TOYBOX_URL="https://www.landley.net/toybox/downloads/binaries/latest/toybox-x86_64"
NAMESERVER="9.9.9.9"
MOTD_TEXT="Have fun with your new distro."
OUTPUT_ISO="/output/boot.iso"

mkdir -p root/{bin,etc} disc/boot/grub

wget -P disc $(curl -s "https://api.github.com/repos/${KERNEL_RELEASES_REPO}/releases/latest" \
| grep "browser_download_url.*bzImage" \
| cut -d : -f 2,3 \
| tr -d \")

wget -O root/toybox "$TOYBOX_URL"
chmod +x root/toybox

pushd root/bin
for toy in $(../toybox); do
        ln -sv /toybox $toy
done
popd

echo "$MOTD_TEXT" > root/etc/motd

echo "nameserver $NAMESERVER" > root/etc/resolv.conf

pushd root
echo '#!/bin/sh
clear
cat /etc/motd
sh
exec /init' > init
chmod +x init

find . | cpio -o -H newc | gzip -9c > ../disc/gzInitramfs
popd

echo 'menuentry "Boot the system now" {
        linux /bzImage quiet
        initrd /gzInitramfs
}' > disc/boot/grub/grub.cfg

grub-mkrescue -o "$OUTPUT_ISO" disc
