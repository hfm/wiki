# Reallocated_Sector_Ct

```text
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0013   100   100   050    Pre-fail  Always       -       0
```

不良セクタを予備セクタへ置換した総数。

ハードドライブがread, write verificationでエラーを起こした際、エラー対象のセクタを予約領域へデータ転送して再配置を施行する。
再配置の数が多いほど、データのread/writeに影響が出る。

## ref

[Current_Pending_Sector](Current-Pending-Sector)