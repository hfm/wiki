# Hardware_ECC_Recovered

S.M.A.R.Tの値チェックで出てくる次の値。

```
195 Hardware_ECC_Recovered  0x003a   100   100   ---    Old_age   Always       -       579627922
```

## 意味

Wikipediaによると、

項目ID | 項目名 | 詳細な説明
------|-------|---------
C3(195) | Hardware ECC recovered | ECC（Error Correction Cord、誤り訂正符号）によって検知されたエラーの回数

ID | Hex | Attribute name | Better | Description
---|-----|----------------|--------|------------
187 | 0xBB | Reported Uncorrectable Errors | ▼ |  The count of errors that could not be recovered using hardware ECC (see attribute 195).
195 | 0xC3 | Hardware ECC Recovered | N/A | (Vendor specific raw value.) The raw value has different structure for different vendors and is often not meaningful as a decimal number.

ということらしい。
（Betterというのは、値が小さければ小さいほど良いという意味）

## 値の見方

エラー回数なので少ないほうが良いのだろうけど、ベンダ固有の値らしく、数値自体はあてにならない。
複数のサーバで見てみると、

```
195 Hardware_ECC_Recovered  0x003a   100   100   ---    Old_age   Always       -       125517375
195 Hardware_ECC_Recovered  0x003a   100   100   ---    Old_age   Always       -       4294967295
195 Hardware_ECC_Recovered  0x003a   100   100   ---    Old_age   Always       -       497355628
```

というように、桁ひとつ違う場合もある。

## 結論

 * `Hardware_ECC_Recovered`自体はベンダ固有の値
   * ディスクごとに値の意味が違っているので、これ自体を参考にしにくい
 * `Reported Uncorrectable Errors`あるいは`Reported_Uncorrect`の方が重要。
   * ECCによるエラーをリカバリ出来なかった数値。
