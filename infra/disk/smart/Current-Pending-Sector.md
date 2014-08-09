# Current_Pending_Sector

```text
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
```

## 意味

不良セクタの数。
代替処理(remapped)待ちや、読み込み不能な回復不能状態のセクタがカウントされる。

代替処理されると、値は減少する。
fsckの実行やblockのゼロクリア(`dd if=/dev/zero of=<dev> seek=<block>`)で回復する場合がある。

セクタ読み込み時にエラーが起きると、ドライブは予約領域へリストアし、そのセクタが代替処理されたことを記録する。

このエラーはクリティカルなため、バックアップを取得するなどしてデータを退避させることが望ましい。

## ref

 * [S.M.A.R.T. Attribute: Current Pending Sector Count | Knowledge Base](http://kb.acronis.com/content/9133)
 * [ぱぱらくだ日記: Linux LVMでのCurrent_Pending_Sectorの対処方法](http://papa3camel.blogspot.jp/2013/07/linux-lvmcurrentpendingsector.html)