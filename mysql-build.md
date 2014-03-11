# mysql-buildメモ

前提として、以下のように各MySQLをインストールした。

```sh
mysql-build/bin/mysql-build -v $VERSION "~/mysql/$VERSION"
```

## DATADIR

`/etc/my.cnf`の無い状態で`mysql_install_db`を実行すると、以下のようなDATADIRになる。
ことDATADIR以下にmy.cnfを置いても認識される。

1. `/etc/my.cnf`が読まれる
1. `DATADIR/my.cnf`が次に読まれる
1. `defaults-extra-file`で指定したものが次に読まれる
1. `~/.my.cnf`が最後に読まれる

という順序になるらしい。
ちなみに5系からは`DATADIR/my.cnf`から`$MYSQL_HOME/my.cnf`にディレクトリが変更されている。

* [MySQL 4.1 リファレンスマニュアル :: 4.1.2 my.cnf オプション設定ファイル](http://dev.mysql.com/doc/refman/4.1/ja/option-files.html)
* [MySQL 5.1 リファレンスマニュアル :: 3.3.2 オプションファイルの使用](http://dev.mysql.com/doc/refman/5.1/ja/option-files.html)

### チェックコマンド

```sql
show variables like "datadir";
```

### 表

| Versions | Value                            | Note                                               |
|----------|----------------------------------|----------------------------------------------------|
| 4.0.30   | /home/vagrant/mysql/4.0.30/var/  |                                                    |
| 4.1.25   | /home/vagrant/mysql/4.1.25/var/  |                                                    |
| 5.0.96   | /home/vagrant/mysql/5.0.96/var/  | Datadir `5.0.96/var/my.cnf` is deprecated. Move to `5.0.96/my.cnf` |
| 5.1.73   | /home/vagrant/mysql/5.1.73/var/  |                                                    |
| 5.5.36   | /home/vagrant/mysql/5.5.36/data/ |                                                    |
| 5.6.16   | /home/vagrant/mysql/5.6.16/data/ |                                                    |

# MySQL 5.6 からの変更点

## Replication

### Reset Slave

> In MySQL 5.6 (unlike the case in MySQL 5.1 and earlier), RESET SLAVE does not change any replication connection parameters such as master host, master port, master user, or master password, which are retained in memory. This means that START SLAVE can be issued without requiring a CHANGE MASTER TO statement following RESET SLAVE.

slaveが機能中にRESET SLAVEしないこと。

### GTID

5.6から使えるGTIDは、my.cnfに以下のような呪文を入れることで起動。
variable scopeはどちらもglobalなので、どこ突っ込んでも良さそう。

gtid-mode=ON
disable-gtid-unsafe-statements
前者は名前通り、後者はGTIDを有効化すると非互換になってしまうSQL実行を止めてしまうもの。
MySQL :: MySQL 5.6 Reference Manual :: 16.1.4.5 Global Transaction ID Options and Variables

# Troubleshoot

## Error

### /etc/my.cnf

mysql-buildは`/etc/my.cnf`を設置しない。
しかし、CentOS 6で`yum update -y`を実行すると、postfix, そしてその依存関係であるmysql-libsがインストールされ、自動的に`/etc/my.cnf`が設置されてしまう。

### [ERROR] Slave I/O: error connecting to master 'repl@192.168.128.4:3306' - retry-time: 60  retries: 86400, Error_code: 2013

iptabelsを見なおしてみよう。

### [ERROR] The slave I/O thread stops because master and slave have different values for the COLLATION_SERVER global variable. The values must be equal for replication to work

文字コードが違ったりすると上記のようなエラーが起こる。
my.cnfの設定や`show variables`でチェックする。

### [ERROR] Error reading packet from server: Could not find first log file name in binary log index file ( server_errno=1236)

bin-logの名前が間違っていて見つからない。
slaveの`MASTER_LOG_FILE`を見直す。

### [ERROR] /home/vagrant/mysql/5.5.36/bin/mysqld: unknown variable 'default-character-set=ujis'

mysql 5.5からは`default-character-set`は`[mysqld]`から廃止されている。

代わりに`character-set-server = ujis`を使う。
clientやdumpではdefault...は使える。