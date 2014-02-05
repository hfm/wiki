# Packer for FreeBSD 10

## VirtualBox用 provision shell

VirtualBoxにFreeBSDをつっこむにあたって、provision shellをどうすればいいか悩んでいたら、以下の公式ドキュメントを発見。

* [21.2. FreeBSD as a Guest OS #VirtualBox™ Guest Additions on a FreeBSD Guest](http://www.freebsd.org/doc/handbook/virtualization-guest.html#virtualization-guest-virtualbox-guest-additions)

ここに書いてあることをそのままシェルに起こした。

```sh
#!/bin/sh

# VMware Fusion specific items
pkg install -y virtualbox-ose-additions

cat <<'EOF' >> /etc/rc.conf

# VirtualBox configuration
vboxguest_enable="YES"
vboxservice_enable="YES"
vboxservice_flags="--disable-timesync"
EOF

exit
```