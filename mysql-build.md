# mysql-buildメモ

DATADIRを何も設定しないと、DATADIRは以下になる。
`/etc/my.cnf`以外に設置する場合は、以下を参考にする。

```sql
[vagrant@localhost 4.0.30]$ bin/mysql -uroot -e 'show variables like "datadir"'
+---------------+---------------------------------+
| Variable_name | Value                           |
+---------------+---------------------------------+
| datadir       | /home/vagrant/mysql/4.0.30/var/ |
+---------------+---------------------------------+

[vagrant@localhost 4.1.25]$ bin/mysql -uroot -ppassword -e 'show variables like "datadir"'
+---------------+---------------------------------+
| Variable_name | Value                           |
+---------------+---------------------------------+
| datadir       | /home/vagrant/mysql/4.1.25/var/ |
+---------------+---------------------------------+
```