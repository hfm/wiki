# Weechat

## プラグイン

かつては`weeget`だったけど、今は`script`と打てばパッケージリストが表示されて簡単にインストールできるようになってる。
`~/.weechat/script/plugins.xml.gz`にダウンロードされるらしい。

入れたやつ：

 * buffers.pl ...
 * chanmon.pl ...
 * expand_url.pl ...
 * highmon.pl ...
 * iset.pl ...
 * autoconnect.py ...
 * go.py ...
 * notification_center.py ...
 * beep.pl ...

## 設定

freenodeを削除
```
/server del freenode
```

join/part/quit を非表示にする
```
/filter add joinquit * irc_join,irc_part,irc_quit *
```
## サーバ追加

```
/server add <server> <hostname>/+<port> -ssl -password=<znc.username>/<znc.network>:<znc.password> -autoconnect
/set irc.server.<server>.ssl_verify off
/save
/connect <server>
```

## ハマったこと

### keybindについて

`/key bind ctrl-g /go`ではなく`/key bind ctrl-G /go`でやる。