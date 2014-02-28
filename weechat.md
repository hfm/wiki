# Weechat

## プラグイン

かつては`weeget`だったけど、今は`script`と打てばパッケージリストが表示されて簡単にインストールできるようになってる。
`~/.weechat/script/plugins.xml.gz`にダウンロードされるらしい。

入れたやつ：

 * 

## サーバ追加

```
/server add <server> <hostname>/+<port> -ssl -password=<znc.username>/<znc.network>:<znc.password> -autoconnect
/set irc.server.BNC.ssl_verify off
/save
/connect <server>
```

## ハマったこと

### keybindについて

`/key bind ctrl-g /go`ではなく`/key bind ctrl-G /go`でやる。