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

# master/slave

## 同一ホスト上でmaster/slave構成を取りたい場合

前提：同一ホスト上に複数のMySQLを起動するにあたり、portとsocketを変えて立ち上げている。

作業としては、一般的な`CHANGE MASTER TO`構文に`MASTER_PORT`を付け加える。

```sql
mysql> CHANGE MASTER TO
MASTER_HOST='192.168.128.2',
MASTER_PORT=3308,
MASTER_USER='repl',
MASTER_PASSWORD='password',
MASTER_LOG_FILE='localhost-bin.000007',
MASTER_LOG_POS=714717068;

mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State:
                  Master_Host: 192.168.128.2
                  Master_User: repl
                  Master_Port: 3308 ←ここをチェック。
                Connect_Retry: 60
              Master_Log_File: localhost-bin.000007
          Read_Master_Log_Pos: 714717068
               Relay_Log_File: localhost-relay-bin.000001
                Relay_Log_Pos: 4
        Relay_Master_Log_File: localhost-bin.000007
             Slave_IO_Running: No
            Slave_SQL_Running: No
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 714717068
              Relay_Log_Space: 120
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: NULL
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 0
                  Master_UUID:
             Master_Info_File: /home/vagrant/mysql/5.6.16/data/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State:
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set:
                Auto_Position: 0
1 row in set (0.00 sec)
```

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

### TIMESTAMP

TIMESTAMPのDEFAULT値は明示的に設定しなければいけないようになっている。
いずれremovedの運命にあるので、my.cnfに`explicit_defaults_for_timestamp`を入れて対応する。

ただし5.6.6からこの項目が入ったので、それ以下のバージョンでは動作が保証されない。

```
[Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
```

 * [MySQL :: MySQL 5.6 Reference Manual :: 5.1.4 Server System Variables](http://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_explicit_defaults_for_timestamp)

# Troubleshoot

## Warning

### [Warning] Neither --relay-log nor --relay-log-index were used; so replication may break when this MySQL server acts as a slave and has his hostname changed!! Please use '--relay-log=localhost-relay-bin' to avoid this problem.

`--relay-log`と`--relay-log-index`をどっちも使っていないと、slave側のhostnameが変わると死ぬ？

`--relay-log=localhost-relay-bin`を使って、relayログをlocalhost-relay-binに仕向けたほうが良い。

```sql
mysql> show variables like "%relay_log%";
+-----------------------+----------------+
| Variable_name         | Value          |
+-----------------------+----------------+
| max_relay_log_size    | 0              |
| relay_log             |                | ←どっちも無いと死ぬ
| relay_log_index       |                |
| relay_log_info_file   | relay-log.info |
| relay_log_purge       | ON             |
| relay_log_space_limit | 0              |
+-----------------------+----------------+
```

## Error

### /etc/my.cnf

mysql-buildは`/etc/my.cnf`を設置しない。
しかし、CentOS 6で`yum update -y`を実行すると、postfix, そしてその依存関係であるmysql-libsがインストールされ、自動的に`/etc/my.cnf`が設置されてしまう。

#### [ERROR] Slave I/O: error connecting to master 'repl@192.168.128.4:3306' - retry-time: 60  retries: 86400, Error_code: 2013

iptabelsを見なおしてみよう。

#### [ERROR] The slave I/O thread stops because master and slave have different values for the COLLATION_SERVER global variable. The values must be equal for replication to work

文字コードが違ったりすると上記のようなエラーが起こる。
my.cnfの設定や`show variables`でチェックする。

#### [ERROR] Error reading packet from server: Could not find first log file name in binary log index file ( server_errno=1236)

bin-logの名前が間違っていて見つからない。
slaveの`MASTER_LOG_FILE`を見直す。

#### [ERROR] 5.5.36/bin/mysqld: unknown variable 'default-character-set=ujis'

mysql 5.5からは`default-character-set`は`[mysqld]`から廃止されている。

代わりに`character-set-server = ujis`を使う。
clientやdumpではdefault...は使える。

#### [ERROR] 5.6.16/bin/mysqld: ambiguous option '--log=/home/vagrant/mysql/5.6.16/var/log/mysql/query.log' (log-bin, log_slave_updates)

general_logとgeneral_log_fileに置き換わった。

#### [ERROR] 5.6.16/bin/mysqld: unknown variable 'log-slow-queries=/home/vagrant/mysql/5.6.16/var/log/mysql/slow.log'

> [MySQL :: MySQL 5.5 Reference Manual :: 5.2.5 The Slow Query Log](http://dev.mysql.com/doc/refman/5.5/en/slow-query-log.html)
> 
> By default, the slow query log is disabled. To specify the initial slow query log state explicitly, use ***--slow_query_log[={0|1}]***. With no argument or an argument of 1, --slow_query_log enables the log. With an argument of 0, this option disables the log. To specify a log file name, use ***--slow_query_log_file=file_name***. The older option to enable the slow query log file, --log-slow-queries, is deprecated.

`--log`と同様に、`--slow_query_log`と`--slow_query_log_file`にせよとのこと。

#### [ERROR] 5.6.16/bin/mysqld: unknown variable 'table_cache=16'

`table_open_cache`に変わったらしい。
5.1.2から変わったらしいけど、5.5でも動いた。

> [MySQL :: MySQL 5.1 Reference Manual :: 8.8.3 How MySQL Opens and Closes Tables](http://dev.mysql.com/doc/refman/5.1/en/table-cache.html)
> 
> #### Note
> table_open_cache was known as table_cache in MySQL 5.1.2 and earlier.

#### [ERROR] Slave I/O: The slave I/O thread stops because a fatal error is encountered when it try to get the value of TIME_ZONE global variable from master. Error: Unknown system variable 'TIME_ZONE', Error_code: 1193

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

#### [Warning] No argument was provided to --log-bin, and --log-bin-index was not used; so replication may break when this MySQL server acts as a master and has his hostname changed!! Please use '--log-bin=localhost-bin' to avoid this problem.

名前つけろエラー。

```ini
[mysqld]
log-bin=localhost-bin
```

#### [Warning] Neither --relay-log nor --relay-log-index were used; so replication may break when this MySQL server acts as a slave and has his hostname changed!! Please use '--relay-log=localhost-relay-bin' to avoid this problem.

名前つけろエラー。

```ini
[mysqld]
relay_log=localhost-relay-bin
```

#### [Warning] Using unique option prefix thread_cache instead of thread_cache_size is deprecated and will be removed in a future release. Please use the full name instead.

```diff
-thread_cache            = 128
+thread_cache_size       = 128
```

#### [Warning] Buffered warning: Could not increase number of max_open_files to more than 1024 (request: 8192)

ulimitの問題っぽい？

```console
[vagrant@localhost]~/mysql/5.6.16% bin/mysql -uroot -e 'show variables like "open_files_limit"'
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| open_files_limit | 1024  |
+------------------+-------+
```