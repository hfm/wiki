# Hiera

http://docs.puppetlabs.com/hiera/1/index.html

## Overview

Hieraはkey/value型(yaml, json)の設定データ検索ツール。
ノードごとの設定値をHieraに記述することで、マニフェストからノード固有設定を分離する。

例:

- MySQLやbasic認証のパスワード
- オリジナルyumserverのアドレス
- production, integration, development環境において値の異なる変数

## インストール

RHEL系ならyumから入る。
詳細は[こちら](http://docs.puppetlabs.com/hiera/1/installing.html)。

## 設定ファイル

### hiera.yaml

hieraに関するデータディレクトリやデータ形式を決定するメタデータ

url: http://docs.puppetlabs.com/hiera/1/configuring.html

#### 設置場所

正確には読み込み場所．

Puppet自体が読む場合，デフォルトは`$confdir/hiera.yaml`

OpenSource版のPuppetなら`/etc/puppet/hiera.yaml`に設置しても読み込まれる。
また、`puppet.conf`にhiera.yamlの位置を指定することも可能。

### 記法

例えば以下のような設定が記述される。デフォルト値から変更しないものは省いても良い。

```yaml
---
:yaml:
  :datadir: "%{settings::confdir}/hieradata/%{::environment}"
:hierarchy:
  - common
```

- ハッシュのキーはRubyのシンボル（colon `:`のプレフィクス）でなければならない
- `:yaml:`にはデータディレクトリの位置を書いている
 - `%{settings::confdir}`は、puppetmasterが所持している[Reserved Variables](http://docs.puppetlabs.com/puppet/latest/reference/lang_facts_and_builtin_vars.html#variables-set-by-the-puppet-master)
 - `%{::environment}`は、例えば`production`や`development`等を設定し、hieradataディレクトリ以下に名前に対応したディレクトリを設置する。


### グローバル設定

#### `:hierarchy`

- `hiera.yaml`のトップレベルに`:hierarchy`キーとその値を設定することで、Hieraはヒエラルキデータをロードすることが出来る。

例：

```yaml
:hierarchy:
  - one
  - two
  - three
```

- この場合、Hieraは __上から順番に__ 探していく ([ref](http://docs.puppetlabs.com/hiera/1/hierarchy.html#ordering))
- `one`の中に目的のデータがなければ次の`two`へ、同様の結果であればその次の`three`へと検索対象が遷移する。
  - （あるいは`one`そのものが見つからない場合も次の対象を検索するようになるらしい。）

#### `:backends`

- ヒエラルキーを確認する時に使う仕組み．デフォルトは`yaml`．
- 他にも`json`が選択可能．Custom Backendの仕組みを用いれば，新しいBackendの提供可能．

#### `:logger`

- 渓谷やデバッグメッセージの送り先を指定する
- デフォルトは`console`で，STDERRに送るが，Puppetはこれを`puppet`(puppetのログシステムに送る)に上書きするようになっている．
- 他に，`noop` (何も出力しない) も選択可能．

#### `:merge_behavior`

- 各yamlに重複する設定が記述されている際のmergeの挙動を示す．
- `native`, `deep`, `deeper`から選択可能．後者ほど，複数の設定を複雑に混合するようになる（`native`だと，片側のみ採用するような挙動もある）．

### バックエンド用設定
#### `:yaml`と`:json`
#### `:puppet`
