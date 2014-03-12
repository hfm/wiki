# mysql-buildメモ

前提として、以下のように各MySQLをインストールした。

```sh
mysql-build/bin/mysql-build -v $VERSION "~/mysql/$VERSION"
```

## 便利

[黒田さん](https://twitter.com/lamanotrama/)に教えてもらった。バージョンごとのvariablesや機能の比較表。

* [MySQL :: MySQL Server Version Reference :: 1 mysqld Option/Variable Reference](https://dev.mysql.com/doc/mysqld-version-reference/en/mysqld-version-reference-optvar.html)

# my.cnf

## DATADIR, $MYSQL_HOMEについて

`mysql_install_db`を実行すると、以下のようなDATADIRになる (5.1からは$MYSQL_HOMEという名称に変更されている)。

```sql
mysql> show variables like "datadir";
```

| Versions | Value                            |
|----------|----------------------------------|
| 4.0.30   | /home/vagrant/mysql/4.0.30/var/  |
| 4.1.25   | /home/vagrant/mysql/4.1.25/var/  |
| 5.0.96   | /home/vagrant/mysql/5.0.96/var/  |
| 5.1.73   | /home/vagrant/mysql/5.1.73/var/  |
| 5.5.36   | /home/vagrant/mysql/5.5.36/data/ |
| 5.6.16   | /home/vagrant/mysql/5.6.16/data/ |

mysqlは特定ディレクトリから`my.cnf`を読み込む。順序は次の通り。

1. `/etc/my.cnf`
1. バージョンごとの `datadir/my.cnf`
1. `defaults-extra-file`で指定したもの
1. `~/.my.cnf`

どのmy.cnfが読まれているかを調べるには、`mysql --help | grep my.cnf`を実行する。

 * 4.0.30:
   * `/etc/my.cnf` `/home/vagrant/mysql/4.0.30/var/my.cnf` `~/.my.cnf`
 * 4.1.25:
   * `/etc/my.cnf` `/home/vagrant/mysql/4.1.25/var/my.cnf` `~/.my.cnf`
 * 5.0.96:
   * `/etc/my.cnf` `/home/vagrant/mysql/5.0.96/etc/my.cnf` `~/.my.cnf`
 * 5.1.73:
   * `/etc/my.cnf` `/etc/mysql/my.cnf` `/home/vagrant/mysql/5.1.73/etc/my.cnf` `~/.my.cnf`
 * 5.5.36:
   * `/etc/my.cnf` `/etc/mysql/my.cnf` `/home/vagrant/mysql/5.5.36/etc/my.cnf` `~/.my.cnf`
 * 5.6.16:
   * `/etc/my.cnf` `/etc/mysql/my.cnf` `/home/vagrant/mysql/5.6.16/etc/my.cnf` `~/.my.cnf`

上記以外にmy.cnfを設置した場合、`mysql`や`mysqld_safe`コマンドでは読み込まれるが、`mysqladmin`では読み込まれない、といったコマンドごとの差異が発生するおそれがある。

更に、5系からはinclude機能も追加されたので、そちらを活用するのも良い。

* [MySQL 4.1 リファレンスマニュアル :: 4.1.2 my.cnf オプション設定ファイル](http://dev.mysql.com/doc/refman/4.1/ja/option-files.html)
* [MySQL 5.1 リファレンスマニュアル :: 3.3.2 オプションファイルの使用](http://dev.mysql.com/doc/refman/5.1/ja/option-files.html)

# MySQL 5.6 からの変更点

## Replication

### Reset Slave

> In MySQL 5.6 (unlike the case in MySQL 5.1 and earlier), RESET SLAVE does not change any replication connection parameters such as master host, master port, master user, or master password, which are retained in memory. This means that START SLAVE can be issued without requiring a CHANGE MASTER TO statement following RESET SLAVE.

slaveが機能中にRESET SLAVEしないこと。

### GTID

5.6から使えるGTIDは、my.cnfに以下のような呪文を入れることで起動。
variable scopeはどちらもglobalなので、どこ突っ込んでも良さそう。

```ini
gtid-mode=ON
disable-gtid-unsafe-statements
```

前者は名前通り、後者はGTIDを有効化すると非互換になってしまうSQL実行を止めてしまうもの。
MySQL :: MySQL 5.6 Reference Manual :: 16.1.4.5 Global Transaction ID Options and Variables

```sql
mysql> show variables like "%gtid%";
+--------------------------+-----------+
| Variable_name            | Value     |
+--------------------------+-----------+
| enforce_gtid_consistency | OFF       |
| gtid_executed            |           |
| gtid_mode                | OFF       |
| gtid_next                | AUTOMATIC |
| gtid_owned               |           |
| gtid_purged              |           |
+--------------------------+-----------+
```

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

### [ERROR] 5.5.36/bin/mysqld: unknown variable 'default-character-set=ujis'

mysql 5.5からは`default-character-set`は`[mysqld]`から廃止されている。

代わりに`character-set-server = ujis`を使う。
clientやdumpではdefault...は使える。

### [ERROR] 5.6.16/bin/mysqld: ambiguous option '--log=/home/vagrant/mysql/5.6.16/var/log/mysql/query.log' (log-bin, log_slave_updates)

general_logとgeneral_log_fileに置き換わった。

### [ERROR] 5.6.16/bin/mysqld: unknown variable 'log-slow-queries=/home/vagrant/mysql/5.6.16/var/log/mysql/slow.log'

> [MySQL :: MySQL 5.5 Reference Manual :: 5.2.5 The Slow Query Log](http://dev.mysql.com/doc/refman/5.5/en/slow-query-log.html)
> 
> By default, the slow query log is disabled. To specify the initial slow query log state explicitly, use ***--slow_query_log[={0|1}]***. With no argument or an argument of 1, --slow_query_log enables the log. With an argument of 0, this option disables the log. To specify a log file name, use ***--slow_query_log_file=file_name***. The older option to enable the slow query log file, --log-slow-queries, is deprecated.

`--log`と同様に、`--slow_query_log`と`--slow_query_log_file`にせよとのこと。

### [ERROR] 5.6.16/bin/mysqld: unknown variable 'table_cache=16'

`table_open_cache`に変わったらしい。
5.1.2から変わったらしいけど、5.5でも動いた。

> [MySQL :: MySQL 5.1 Reference Manual :: 8.8.3 How MySQL Opens and Closes Tables](http://dev.mysql.com/doc/refman/5.1/en/table-cache.html)
> 
> #### Note
> table_open_cache was known as table_cache in MySQL 5.1.2 and earlier.

### [ERROR] Slave I/O: The slave I/O thread stops because a fatal error is encountered when it try to get the value of TIME_ZONE global variable from master. Error: Unknown system variable 'TIME_ZONE', Error_code: 1193

```
+--------------+   Replication  +-------------+
| master (4.0) | <------------- | slave (5.1) |
+--------------+                +-------------+
```

をやろうとして`Slave_IO_Running: No`になった。

「master dbから`TIME_ZONE`というグローバル変数を取ってこようとしたけど、そのような値が見つかりません」というエラー。

どうやらMySQL 5.1系あたりから、MASTER DBの`time_zone`を参照しており、それができないとエラーを出すようになったらしい。

```sql
@ 4.0.30
mysql> show variables like "time%zone";
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| timezone      | JST   |
+---------------+-------+

@4.1.25
mysql> show variables like "time%zone";
+---------------+--------+
| Variable_name | Value  |
+---------------+--------+
| time_zone     | SYSTEM |
+---------------+--------+

@5.0.73
mysql> show variables like "time%zone";
+---------------+--------+
| Variable_name | Value  |
+---------------+--------+
| time_zone     | SYSTEM |
+---------------+--------+

@ 5.1.73
mysql> show variables like "%time%zone%";
+------------------+--------+
| Variable_name    | Value  |
+------------------+--------+
| system_time_zone | JST    | ←これなんぞー
| time_zone        | SYSTEM |
+------------------+--------+
```