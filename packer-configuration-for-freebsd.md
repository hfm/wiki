# Packer for FreeBSD 10

### `execute_command`の注意事項

 * [Shell Provisioner - Packer](http://www.packer.io/docs/provisioners/shell.html)

`provisioner`フェーズで、sudo権限が必要な`execute_command`を実行するときに、以下の状態から先へ進まなくなってしまうことがある。

```console
    virtualbox-iso: We trust you have received the usual lecture from the local System
    virtualbox-iso: Administrator. It usually boils down to these three things:
    virtualbox-iso:
    virtualbox-iso:
    virtualbox-iso: #1) Respect the privacy of others.
    virtualbox-iso: #2) Think before you type.
    virtualbox-iso: #3) With great power comes great responsibility.
```

これは作成したユーザがsudo権限で何かを実行しようとした時にパスワードを求められる画面だ。
この対処方法は上記URLのドキュメントに書いてあるとおり、以下のコマンドを実行する。

```sh
echo 'packer' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'
```

ここで出てくる`'packer'`は`builders`で設定した`ssh_password`の値である。
sudoの`-E`は環境変数の引き継ぎ、`-S`はパスワードの標準入力からの受付を意味する。
echoで出力されたものをパイプして与えているわけである。

## VirtualBox用 provision scripts


VirtualBoxにFreeBSDをつっこむにあたって、provision scriptsをどうすればいいか悩んでいたら、以下の公式ドキュメントを発見。

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