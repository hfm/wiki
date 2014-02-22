# `$HOME/vagrant.d`

packerで箱を作っては中を試している場合、`$HOME/vagrant.d`の中身を確認すること。
一度、Vagrantfileにnameを付けて`vagrant up`してしまうと、先の中にキャッシュされてしまう。

一度キャッシュされると、同じ名前を使って`vagrant up`する限り、そのキャッシュが使われてしまい、指定したboxが有効になっていないことがある。
気になったら、以下のようにbox listを出してみよう。

```console
$ vagrant box list
CentOS-6.4-x84_64               (virtualbox)
CentOS-6.4-x86_64-Minimal       (virtualbox)
CentOS-6.4-x86_64-v20130731     (virtualbox)
CentOS-6.5-x86_64               (virtualbox)
CentOS5.10-i386-mysql-allstar   (virtualbox)
CentOS5.10-x86_64-mysql-allstar (virtualbox)
FreeBSD-10-CURRENT              (virtualbox)
FreeBSD-10.0-amd64              (virtualbox)
FreeBSD-10.0-i386               (virtualbox)
FreeBSD-9.2-amd64               (virtualbox)
centos65-x86_64-20131205        (virtualbox)
```

`vagrant box remove <name>`で削除できるが、ずっと残っていても重たくて邪魔なので全部一気に削除することもある。
そういう時は次みたいなコマンドで一気に消せばいい。

```console
$ vagrant box list | awk '{print $1}' | xargs -I % vagrant box remove %
Removing box 'CentOS-6.4-x84_64' with provider 'virtualbox'...
Removing box 'CentOS-6.4-x86_64-Minimal' with provider 'virtualbox'...
Removing box 'CentOS-6.4-x86_64-v20130731' with provider 'virtualbox'...
Removing box 'CentOS-6.5-x86_64' with provider 'virtualbox'...
Removing box 'CentOS5.10-i386-mysql-allstar' with provider 'virtualbox'...
Removing box 'CentOS5.10-x86_64-mysql-allstar' with provider 'virtualbox'...
Removing box 'FreeBSD-10-CURRENT' with provider 'virtualbox'...
Removing box 'FreeBSD-10.0-amd64' with provider 'virtualbox'...
Removing box 'FreeBSD-10.0-i386' with provider 'virtualbox'...
Removing box 'FreeBSD-9.2-amd64' with provider 'virtualbox'...
Removing box 'centos65-x86_64-20131205' with provider 'virtualbox'...
```

※box nameに半角スペースを使うと非常にめんどくさくなるので気をつけること。