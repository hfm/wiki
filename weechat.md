# Weechat

## プラグイン

かつては`weeget`だったけど、今は`script`と打てばパッケージリストが表示されて簡単にインストールできるようになってる。
`~/.weechat/script/plugins.xml.gz`にダウンロードされるらしい。

### buffers.pl (Sidebar with list of buffers)

チャンネルバッファを表示する。

### chanmon.pl (Channel Monitor)

指定したチャンネル（デフォルトはjoinしてる奴全部？）のやりとりが流れてくる。

### expand_url.pl (Get information on a short URL. Find out where it goes.)

tinyurlやbit.lyのような短縮URLが流れてくると、自動でexpandする。

### highmon.pl (Highlight Monitor)

ハイライトキーワードに反応したコメントだけが流れてくる。

### iset.pl (Interactive Set for configuration options)

weechatの設定が一覧表示される。
設定も変更できるので便利。

### listsort.pl (Sort the output of /list command by user count)

各サーバで`/list`ってやる時に出るチャンネルリストをユーザが多い順にソートしてくれる。

### autosort_buffers.py (Automatically keeps buffers grouped by server and sorted by name.)

buffersのリストを自動sortしてくれる。
サーバごとに並べてくれるので、新しくチャンネルにjoinした時に便利。

### colorize_nicks.py (Use the weechat nick colors in the chat area)

nickに色を付けてくれるので、発言欄が見やすくなる。

### go.py (Quick jump to buffers)

指定したチャンネルに移動出来る。

### grep.py (Search in buffers and logs)

チャンネルで`/grep hoge`とうつと、ログから`hoge`を漁ってくれる。

### listbuffer.py (A common buffer for /list output.)

`/list`で吐き出した内容をバッファしてくれる。

### urlbuf.py (A common buffer for received URLs.)

joinしてるチャンネルでなんらかのURLが投稿されたら、`#urlbuf`というバッファに貯めこんでくれる。
なんのURLか文脈がわからないまま保存されるので、あまり役に立ってない。

### prism.py (Taste the rainbow.)

文字列をカラフルに出来たりするジョークツール。

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

## atig.rb

- chanmonに要らないやつ
 - `#twitter` ... メインのタイムライン
 - `#retweet` ... いろんな人がRTが流れてくるタイムライン
 - 各種リスト
- chanmonにあってもいいやつ
 - `#mention` ... highmonにも流れてくるけど、別にchanmonにあっても構わない

`/chmonitor #channel server`でモニタリングを切り替え出来るので、要らないやつだけ以下のようにoffにする

```text
/chmonitor #twitter twitter
/chmonitor #retweet twitter
/chmonitor #list twitter
```