# yumに関するエトセトラ

## セキュリティチェック

### yum-security

yumのセキュリティプラグイン．
`yum install yum-security`で導入可能．

セキュリティ関連のアップデート情報のみを取得することが出来るようになる．
`yum --security (update|check-update)`という用に，`security`というオプションを付けることで実行可能になる．

yum-securityパッケージは，他にも`updateinfo (info|list|summary) `で更新情報を出せるようになったりする．
例: `yum updateinfo list bugzillas`のように，BugZillaやCVE, Security, BugFixの絞り込みも可能．