# Memorandum

個人的なメモを取るためのリポジトリです。

## 使い方

### 必要なファイル

`auth.yml`というファイルに`username`と`password`をいれときます。
※めんどくさい場合は`config.ru`のbasic認証部分を書き換えます。

```yaml
username: foo
password: bar
```

### とりあえず立ち上げる

```console
$ bundle install --path vendor
$ bundle exec rackup
```

### nginxとかでがんばる

unicornいれたので多分以下で動くはず。

```console
$ bundle exec unicorn -c config/unicorn.rb -D
```

## GitHubとの同期方法

gitのhookを利用しようと思ったけど、gollumから更新すると何故か動いてくれないのでcronかwheneverあたりで頑張る予定。

以下のコードを1時間とぐらいに走らせればとりあえず動くには動く。ひどいけど。

```rb
require 'git'

repo = Git.init
repo.push(repo.remote('origin'))
```