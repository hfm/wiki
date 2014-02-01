# IP/CIDRリストの作成

## 動機

特定の国のIPを全部弾きたくて、IP/CIDRの形式のリストを作れないかと思った。

 * ref: [特定の国からのアクセスを弾く | でびあんのがらくた箱](http://www.kvs.jp/archives/2369)

## やり方

### 国別IPアドレスリストの入手

apnicの国別に振り分けられたIPアドレスのリストを取ってくる

 * http://ftp.apnic.net/stats/apnic/delegated-apnic-extended-latest
 * http://ftp.apnic.net/stats/ripe-ncc/delegated-ripencc-extended-latest

中にはこんな感じのがリストになってる、
（asmやipv6もあるが今回は割愛。）

```
apnic|CN|ipv4|1.0.2.0|512|20110414|allocated|A92E1062
```

### データの整形

awkで計算、出力する。

```sh
awk '{FS="|"} {OFS="/"} /^apnic\|CN\|ipv4/ {print $4, 32 - log($5) / log(2)}' delegated-apnic-extended-latest
```

そうすると、さっきのリストがIP/CIDRで出力される。

```
1.0.2.0/23
```

curlとパイプで一行でもかけるけど、サーバへの負荷になるので手元でダウンロードして使うこと。

## このリストの使い方

例えばスパムの多い中国やロシアのIP/CIDRのテキストリストを作って、まるっとiptablesで弾くとか。

## 補足

### CIDRの計算について

4番目の1.0.2.0がIPアドレスの開始地点、5番目の`512`が開始地点から割り当てられた個数となる。

```
# 再掲
apnic|CN|ipv4|1.0.2.0|512|20110414|allocated|A92E1062
```

512個という値をCIDRに変換するには2が底のlogを取れば良い。

$$ 2^{n}=512 $$

$$ n\log_{2}(2) = \log_{2}(512) \log_{2}(2^9) = 9 $$