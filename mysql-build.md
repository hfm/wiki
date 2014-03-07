# mysql-buildメモ

前提として、以下のように各MySQLをインストールした。

```sh
mysql-build/bin/mysql-build -v $VERSION "~/mysql/$VERSION"
```

## DATADIR

`/etc/my.cnf`の無い状態で`mysql_install_db`を実行すると、以下のようなDATADIRになることがわかった。

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

# Troubleshoot

## Error

### [ERROR] The slave I/O thread stops because master and slave have different values for the COLLATION_SERVER global variable. The values must be equal for replication to work

文字コードが違ったりすると上記のようなエラーが起こる。
my.cnfの設定や`show variables`でチェックする。