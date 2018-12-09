#!/bin/bash
echo '/dev/sda3  /var/lib/libvirt/images/ ext4  defaults 0 0
/dev/sda5  /iso                    ext4  defaults 0 0
/dev/sda6  /content/               ext4  defaults 0 0
' >> /etc/fstab
mkdir /iso
mkdir /content
mount -a
