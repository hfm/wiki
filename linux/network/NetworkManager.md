# NetworkManagerについてのメモ

## 資料： [RHEL7/CentOS7 NetworkManager徹底入門](http://www.slideshare.net/enakai/rhel7-network-managerv10)

- http://www.slideshare.net/enakai/rhel7-network-managerv10

### 気になったところ

#### RHEL7でNetworkManagerはデフォルトのネットワーク管理機能

- **利用必須**
- RHEL6以下みたいに削除したりOffにしたりは出来なさそう

#### NICネーミングルール

- 別資料: [RHEL7のNICのネーミングルール - めもめも](http://d.hatena.ne.jp/enakai00/20140728/1406504163)
  - Predictable Network Interface Namesと言うらしい
  - 「予測可能なネットワークインターフェイス名」
  - http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames
- ざっくりまとめると，以下の部位に分かれる
  - イーサネット/ワイヤレス (en/wl)
  - オンボード/PCI Express (o/s)
  - デバイス番号
- eno1とかwls2とかになる
- BIOSから論理番号が取得できないとPCIの物理的な場所，すなわちバスとスロット番号で割り当てられる
  - `p<Bus>s<Slot>`
  - enp1s1とか