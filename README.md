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