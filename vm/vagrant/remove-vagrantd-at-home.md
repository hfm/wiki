# `$HOME/vagrant.d`

## `$HOME/vagrant.d`の落とし穴

packerでboxを作る際は、`$HOME/vagrant.d`の中身をちゃんと確認すること。
Vagrantfileに`config.box`名をつけて`vagrant up`すると、`$HOME/vagrant.d/box`にboxデータがキャッシュされる。

実はこれが罠で、packerで何度boxを作りなおしても、同じbox名のまま`vagrant up`しても、そのキャッシュが使われてしまう。
これは`vagrant destroy`したとしても、キャッシュが残る以上、新たに作成したboxは有効にならない。

## box list

おかしいなと思ったら、box listを出してみよう。

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

## box remove

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