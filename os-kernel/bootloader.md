# ブートローダ

ブートマネージャとも。

[FreeBSDのハンドブック](http://www.freebsd.org/doc/ja/books/handbook/boot-introduction.html)の説明が良い。

> [***13.2. 起動時の問題***](http://www.freebsd.org/doc/ja/books/handbook/boot-introduction.html)
> 
> x86 ハードウェアでは、基本入出力システム (Basic Input/Output System: BIOS) にオペレーティングシステムをロードする責任があります。 オペレーティングシステムをロードするために、 BIOS がハードディスク上のマスターブートレコード (Master Boot Record: MBR) を探します。 MBR はハードディスク上の特定の場所になければなりません。 BIOS には MBR をロードし起動するのに十分な知識があり、 オペレーティングシステムをロードするために必要な作業の残りは、 場合によっては BIOS の助けを得た上で MBR が実行できることを仮定しています。
>
> MBR 内部のコードは、 通常ブートマネージャと呼ばれます。 とりわけユーザとの対話がある場合にそう呼ばれます。 その場合は、通常もっと多くのブートマネージャのコードが、 ディスクの最初のトラック または OS のファイルシステム上におかれます (ブートマネージャはブートローダ と呼ばれることもありますが、 FreeBSD はこの言葉を起動のもっと後の段階に対して使います)。 よく使われるブートマネージャには、 **boot0** (**Boot Easy** とも呼ばれる FreeBSD 標準のブートマネージャ), **Grub**, **GAG** や **LILO** 等があります (MBR 内に収まるのは **boot0** だけです)。

## LILO (LInux LOader)

http://lilo.alioth.debian.org/

クラシカルなブートローダで、特定のファイルシステムに依存せず、LinuxだけでなくWindowsなどのOSもブートできる。

Webサイトを見ると、2010年あたりから再スタートを切ったらしく、現在も開発されている模様。

## boot0

FreeBSD標準のブートマネージャ。