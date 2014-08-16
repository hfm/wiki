# [Hiera](http://docs.puppetlabs.com/hiera/1/index.html)

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

### [hiera.yaml](http://docs.puppetlabs.com/hiera/1/configuring.html)

hieraに関するデータディレクトリやデータ形式を決定するメタデータ

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
  - "%{::clientcert}"
  - "%{::environment}"
  - "virtual_%{::is_virtual}"
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

## [ヒエラルキー](https://docs.puppetlabs.com/hiera/1/hierarchy.html)

Hieraはデータを探す時の順序立てられた階層を決めるのに使う．

### Terminology

#### Static data source

静的に決定されたヒエラルキー要素．
全ノードで同じデータを示す．
`common`が該当する．

#### Dynamic data source

動的に決定されたヒエラルキー要素．
ノードごとに異なるデータになる．
`"%{::environment}"`等が該当する．
特に`"%{::clientcert}"`は各ノードでユニークな値になる．

### Ordering

Hieraは次のようなルールでヒエラルキー中の各要素をチェックする．

1. データソースがヒエラルキー中に見つからなければ，次のデータソースへ移動する
1. データソースが存在しても，目的のものでなければ，次のデータソースへ移動する
1. 値が見つかると，次の動作を取る
  - 優先度が普通の検索の場合，Hieraは最初の（リクエストしたデータを保有した）データソースでストップし，その値を返す．
  - 配列の検索の場合，Hieraは検索を続け，発見したすべての値を配列にして返す．
  - ハッシュの検索の場合，Hieraは検索を続け，要求するすべての値をハッシュにし，ハッシュでない値が見つかったらエラーを投げる．見つかったすべてのハッシュはマージされ，結果を返す．
1. Hieraがすべてのヒエラルキーからデータを見つけられなければ，（もしあれば）デフォルト値を使う．デフォルト値が無い場合はエラーを返す．

### Multiple Backends

複数のBackendを`hiera.yaml`に記述出来る．

```yaml
---
:backends:
  - yaml
  - json
:hierarchy:
  - one
  - two
  - three
```

上記のような設定の場合，次のデータソースが順番にチェックされる．

1. `one.yaml`
1. `two.yaml`
1. `three.yaml`
1. `one.json`
1. `two.json`
1. `three.json`

### Example

例えば以下のようなヒエラルキーを仮定する．

```yaml
---
:hierarchy:
  - "%{::clientcert}"
  - "%{::environment}"
  - "virtual_%{::is_virtual}"
  - common
```

そして，clientcertには`app001.example.com`, `app002.example.com`, `db001.example.com`を仮定する．
environmentとしてproduction, developmentを仮定する．
virtual環境はtrueとする．

すると，データソースは次のようになる．

- `app001.example.com`
- `app002.example.com`
- `db001.example.com`
- `production.yaml`
- `development.yaml`
- `virtual_true.yaml`
- `common.yaml`