# Linuxのブートプロセスをみる

## 第１章　ハードウェア

ブートプロセスを見る前の，予備知識の章．
正直いって覚えきれないので，興味を惹いた部分だけメモする．

### モード

- リアルモード
  - 主に8086用に書かれたプログラムを実行させるためのモード
  - ブートローダは最初リアルモードで動き，途中でプロテクトモードへ切り替える
  - x86の大半は，より高度なプロテクトモードで動くのだが，後方互換性のためなのか（？），未だ残されているらしい
- プロテクトモード
  - メモリ管理やタスク管理，保護機能など大幅に機能が拡張されたモード
  - Intel 80386 (後述) で拡張された機能を利用できる
  - 0x00000000から0xFFFFFFFFまでアクセス出来る（32bit, 4GB)
  - 他にもアドレス算出方法や割り込み処理手順等もリアルモードとは大きく異なるため，互換性はまったく無い
- 仮想8086モード
  - プロテクトモードのメモリ管理や保護機能を有効のまま，8086用プログラムが実行できる互換環境モード
- 64bitモード
  - そのまんまのモード．プロテクトモードのアドレスサイズが64bit (16エクサバイト) まで拡張したモード
  - 理論的には16EBだが，現行CPUが物理的に扱えるアドレスは下位40bit (1テラバイト) までらしい
  - EM64Tの __規格上__ の上限は52bit (1ペタバイト) らしく，どれも数字が揃わない
  - 仮想的アドレスで扱える領域は48bit (256テラバイト) 
  - なので現実的には物理領域が40bit, 仮想領域は48bitと覚えておくのが良さそう

### ページング

- 利用可能なモード
  - プロテクトモード
  - IA-32eモード
- Linuxカーネルブート時にCP0レジスタ31bit名のフラグを設定すると有効になる

### "使えない領域"

0xA0000から0xFFFFFまで（640KBから1MB）の領域はメモリホールと呼ばれ，Linuxでは"使えない領域"として扱われている．

この原因は8086 (後述) のメモリアドレス空間との「互換性」にある．
以下に「Linuxのブートプロセスを見る」図1-49の図「予約された物理アドレス領域」を示す．

```
FFFFF +-----------------+
      | System BIOS ROM |
F0000 +-----------------+
      |                 |
      | Expansion card  |
      |                 |
C8000 +-----------------+
      | Video BIOS ROM  |
C0000 +-----------------+
      |                 |
      | Video RAM       |
      |                 |
A0000 +-----------------+
      |                 |
      |                 |
      | Main Meemory    |
      |                 |
      |                 |
00000 +-----------------+
```

0xA0000, つまり640KB以降のメモリアドレス空間はハードウェア用に割り当てられ，この領域にプログラムをロードしたりデータを保存することは出来ない．

空間の後半部分をハードウェア用に割り当てたことによって，1MB以上のメモリが搭載されるようになっても，「互換性」維持のために0xA0000から0xFFFFFの領域を崩すことが出来ず，以下のようなメモリマップになってしまったという．

```
   MAX +------------------+
       |                  |
       |                  |
       |                  |
       | Main Meemory     |
       |                  |
       |                  |
       |                  |
10FF00 +------------------+
       | High Memory Area |
100000 +------------------+
       | Memory Hole      |
 A0000 +------------------+
       |                  |
       | Main Meemory     |
       |                  |
 00000 +------------------+
出典：「Linuxのブートプロセスを見る」
図1-50　使えない領域（メモリホール）
```

OSがメモリ管理をする場合は，このMemory Holeを避けなければならず，処理の複雑さを招いているそうだ．

### 分からなかった用語・意味を忘れてた単語

- [Intel 8086 - Wikipedia](http://ja.wikipedia.org/wiki/Intel_8086)
  - 16bit マイクロプロセッサ
  - 最初のx84アーキテクチャ(x86-16)
  - アドレスバスは20ビットに、データバスは16ビット
- [Intel 80286 - Wikipedia](http://ja.wikipedia.org/wiki/Intel_80286)
  - 16bit マイクロプロセッサ
  - 8086とソフトウェアと上位互換性を持っている
- [Intel 80386 - Wikipedia](http://ja.wikipedia.org/wiki/Intel_80386)
  - 32bit マイクロプロセッサ
  - IA-32(x86-32)
  - 「i386」はこれを指すらしい
  - 互換CPUにも386が付くらしい
- [EM64T (x64)](http://ja.wikipedia.org/wiki/X64)
  - 別名x86-64, IA-32e等
  - x86アーキテクチャの64bit版
- PAE
  - Physical Address Extension，物理アドレス拡張
  - IA-32アーキテクチャで4GiBを超えるメモリを使用できる技術

## 第２章　ブートローダからカーネル起動

ブートローダとカーネルはそれぞれ独立した別のプログラム．
しかし，カーネルはCPUのモード設定やメモリへの配置場所について多くの要求を行う（カーネル自身はやらない）ため，ブートローダはカーネルとは密接な関係になる．

またブートローダの前半部分は（リアルモードの）アセンブリ言語で書かれている．
CPUやメモリの環境設定を設定していくにつれて，C言語のプログラムも実行可能になり，途中からはC言語になっているみたい．

Linuxカーネルはディスクに圧縮ファイルとして保存されているため，カーネル起動前に展開しなければならない．

### BIOSとUEFI

PCの電源を入れてからカーネルが起動するまでの処理は，

```
BIOS -> Boot Sector -> Boot Loader -> Kernel
```

である．最近はBIOSに代わってUEFI (後述) がマザーボードに搭載される場合もあるらしい．
「Linuxのブートプロセスをみる」ではBIOSを前提に書かれている．

### ブートセクタとブートローダ

なぜブートセクタとブートローダは分かれているのか，について．

カーネルは通常のファイルとしてファイルシステム上に保存されていることが多く，BIOSが異なるファイルシステムをサポートしてカーネルをディスクから直接読み込むのは非現実的である．
そこでブートデバイスの最初のセクタだけを読み込むブートセクタの必要が生じる．

通常，ブートセクタはカーネルを直接起動しない．
ディスクからブートローダ・プログラムを読み込んで実行するところまでがブートセクタの仕事になる．

### ブートローダの種類

- LILO
  - LInux LOaderの略称で，昔からあるLinuxブートローダの代名詞のような存在．
- SYSLINUX
  - FATファイルシステムのサポート
  - 及び同ファイルシステム上のファイルからカーネルを起動可能
  - テキストファイルを画面に表示可能
  - カーネル起動時のオプションを指定できるコマンド行編集機能
    - この機能は，DVDやUSBメモリからのカーネル起動にも使える．
- GRUB
- GRUB2
  - 今は大体これだと思う
  - Linux以外にもBSD系OSもサポートしている
  - GRUB 1系と2系は直接の親子関係は無いらしい．
  - むしろGRUB2はfrom scratchとのこと．

「Linuxのブートプロセスを見る」では，Fedora17で使われているGRUB2のブートローダ(ver 2.00~beta4)の動作を解説する．

### GRUB2

#### MBR

Master Boot Recordのこと．ブートセクタの一種で，ディスクの先頭セクタに書かれた512バイトの領域を指す．
中にはブートローダの第一段階とパーティションテーブルが書かれている．
GRUBカーネルを読み込んで起動するまでが仕事．

[`grub-core/boot/i386/pc/boot.S`](https://chromium.googlesource.com/chromiumos/third_party/grub2/+/11508780425a8cd9a8d40370e2d2d4f458917a73/grub-core/boot/i386/pc/boot.S)にMBRのコードが記載されている．

例えば以下は，コメントアウトにある通り，16bit命令であることをGASに教えている．

```asm
	/* Tell GAS to generate 16-bit instructions so that this code works
	   in real mode. */
	.code16
.globl _start, start;
_start:
start:
	/*
	 * _start is loaded at 0x7c00 and is jumped to with CS:IP 0:0x7c00
	 */
	/*
	 * Beginning of the sector is compatible with the FAT/HPFS BIOS
	 * parameter block.
	 */
	jmp	LOCAL(after_BPB)
```

```asm
LOCAL(after_BPB):
/* general setup */
	cli		/* we're not safe here! */
        /*
         * This is a workaround for buggy BIOSes which don't pass boot
         * drive correctly. If GRUB is installed into a HDD, check if
         * DL is masked correctly. If not, assume that the BIOS passed
         * a bogus value and set DL to 0x80, since this is the only
         * possible boot drive. If GRUB is installed into a floppy,
         * this does nothing (only jump).
         */
	. = _start + GRUB_BOOT_MACHINE_DRIVE_CHECK
boot_drive_check:
        jmp     3f	/* grub-setup may overwrite this jump */
        testb   $0x80, %dl
        jz      2f
3:
	/* Ignore %dl different from 0-0x0f and 0x80-0x8f.  */
	testb   $0x70, %dl
	jz      1f
2:	
        movb    $0x80, %dl
1:
	/*
	 * ljmp to the next instruction because some bogus BIOSes
	 * jump to 07C0:0000 instead of 0000:7C00.
	 */
	ljmp	$0, $real_start
```
```asm
real_start:
	/* set up %ds and %ss as offset from 0 */
	xorw	%ax, %ax
	movw	%ax, %ds
	movw	%ax, %ss
	/* set up the REAL stack */
	movw	$GRUB_BOOT_MACHINE_STACK_SEG, %sp
	sti		/* we're safe again */
	/*
	 *  Check if we have a forced disk reference here
	 */
	movb   boot_drive, %al
	cmpb	$0xff, %al
	je	1f
	movb	%al, %dl
1:
	/* save drive reference first thing! */
	pushw	%dx
	/* print a notification message on the screen */
	MSG(notification_string)
	/* set %si to the disk address packet */
	movw	$disk_address_packet, %si
	/* check if LBA is supported */
	movb	$0x41, %ah
	movw	$0x55aa, %bx
	int	$0x13
	/*
	 *  %dl may have been clobbered by INT 13, AH=41H.
	 *  This happens, for example, with AST BIOS 1.04.
	 */
	popw	%dx
	pushw	%dx
	/* use CHS if fails */
	jc	LOCAL(chs_mode)
	cmpw	$0xaa55, %bx
	jne	LOCAL(chs_mode)
	andw	$1, %cx
	jz	LOCAL(chs_mode)
```

- `MSG(notification_string)`の行が読み込まれると，画面に`GRUB`の4文字が表示される
  - たまにkickstartをミスった時に，GRUBの4文字で止まるケースがあったけど，ここだったのか

### 分からなかった用語・意味を忘れてた単語

- UEFI
  - [Unified Extensible Firmware Interface - Wikipedia](http://ja.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface)
  - IntelアーキベースのMacではEFI (UEFIの元となる規格) らしい
- アセンブリ言語の`testb`や`movw`の最後の英文字は`b, w, l`の3つある
  - いずれもコピーするデータの大きさを表す修飾子である
  - それぞれ1バイト，2バイト，4バイト
