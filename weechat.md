# Weechat

## プラグイン

かつては`weeget`だったけど、今は`script`と打てばパッケージリストが表示されて簡単にインストールできるようになってる。
`~/.weechat/script/plugins.xml.gz`にダウンロードされるらしい。

入れたやつ：

 * buffers.pl ... 便利なバッファ
 * chanmon.pl ... 複数チャンネルをシングルバッファ/バーに表示できる
 * expand_url.pl ... 短縮URLを展開してくれる。URI::Findが要る
 * highmon.pl ... ハイライトキーワードのみを表示してくれる
 * iset.pl ... weechatの設定一覧をざっと見れたり、編集できたりして便利
 * autoconnect.py ...
 * go.py ... 簡単にチャンネル移動出来る
 * beep.pl ... beep音

## 設定

初めから入っているfreenodeを削除

```
/server del freenode
```

join/part/quit を非表示にする (smart_filterよりこっちのが好き)

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