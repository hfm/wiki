# Weechat

## プラグイン

かつては`weeget`だったけど、今は`script`と打てばパッケージリストが表示されて簡単にインストールできるようになってる。
`~/.weechat/script/plugins.xml.gz`にダウンロードされるらしい。

入れたやつ：

 - buffers.pl 4.5 (Sidebar with list of buffers)
 - chanmon.pl 2.4 (Channel Monitor)
 - expand_url.pl 0.5 (Get information on a short URL. Find out where it goes.)
 - highmon.pl 2.4 (Highlight Monitor)
 - iset.pl 3.4 (Interactive Set for configuration options)
 - listsort.pl 0.1 (Sort the output of /list command by user count)
 - autoconnect.py 0.2.3 (reopens servers and channels opened last time weechat closed)
 - autosort_buffers.py 1.0 (Automatically keeps buffers grouped by server and sorted by name.)
 - colorize_nicks.py 14 (Use the weechat nick colors in the chat area)
 - go.py 1.9 (Quick jump to buffers)
 - grep.py 0.7.2 (Search in buffers and logs)
 - listbuffer.py 0.8.1 (A common buffer for /list output.)
 - prism.py 0.2.7 (Taste the rainbow.)
 - urlbuf.py 0.1 (A common buffer for received URLs.)

## 設定

### 初めから入っているfreenodeを削除

```text
/server del freenode
```

### join/part/quit を非表示にする

```text
/set irc.look.smart_filter on 
/filter add irc_smart * irc_smart_filter *
/filter add joinquit * irc_join,irc_part,irc_quit *
```

### highlight

```text
/set weechat.look.highlight "$nick,おっくん"
```

### notification

requires

```bash
brew install terminal-notifier
git clone git://github.com/SeTeM/pync.git
cd pync/
sudo python setup.py install # sudo入れないとうまくいかなかった
```

weechat

```text
/script notification_center
```

## サーバ追加

```text
/server add SERVER HOSTNAME/+PORT -ssl -password=ZNC.USERNAME/ZNC.NETWORK:ZNC.PASSWORD -autoconnect
/set irc.server.SERVER.ssl_verify off
/save
/connect SERVER
```

## Tips

### 特定チャンネルの特定のnickを無視する

不要なアラートとか通知飛ばしまくるNICKがいるとたまにこれで無視する。

```plain
/ignore add NICK SERVER #CHANNEL
```

### チャットウィンドウだけコピペしたい for iTerm2

option + commandを押して矩形選択モードを使う。
tmux上で起動しても大丈夫。

### keybindについて

`/key bind ctrl-g /go`ではなく`/key bind ctrl-G /go`でやる。