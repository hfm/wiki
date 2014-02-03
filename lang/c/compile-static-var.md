> 詳解Cポインタ p.45より
>
> コンパイラの観点では、変数宣言に伴う初期化演算子`=`と、代入演算子`=`は異なるものです。

あとで整理する。

```
14:26 okkun: 変数宣言に伴う初期化演算子=と、代入演算子=は、コンパイラの観点からすると異なる情報
14:26 okkun: http://en.wikipedia.org/wiki/Initialization_(programming)
14:27 okkun: 詳解Cポインタ p.45にそう書いてあったけど、具体的にどう異なるのかがいまいちわからない
14:27 okkun: ↑のアドレスに書いてあるのがちょっと詳しいかな
14:27 okkun: 知ったところで何になる情報すぎる気がする。。。
14:27 okkun: ただ、
14:28 okkun: static int *pi = malloc(sizeof(int)); を実行しようとするとコンパイルエラーを吐かれるのは、上記の理由でしっくり来る。
14:29 okkun: あ、いや、
14:29 okkun: 静的な変数を初期化するときに、関数呼び出しがそもそも出来ないから、違う理由なのかな
14:29 okkun: ↑同時に出来ない。
14:30 okkun: static int *pi;
14:30 okkun: pi = malloc(sizeof(int));
14:30 okkun: は出来る。
14:31 okkun: この辺よくわかんない
14:31 okkun: ＼\ ｵﾃヽ(^。^)ノｱｹﾞ /／
14:46 hiroyan: コンパイルエラーの内容はなんだろう
14:48 hiroyan: > 静的な変数を初期化するときに、関数呼び出しがそもそも出来ないから、違う理由なのかな
14:48 hiroyan: であってそう
14:48 okkun: $ clang static.c
14:48 okkun: static.c:5:22: warning: implicitly declaring library function 'malloc' with type 'void *(unsigned long)'
14:48 okkun:    static int *pi = malloc(sizeof(int));
14:48 okkun:                     ^
14:48 okkun: static.c:5:22: note: please include the header <stdlib.h> or explicitly provide a declaration for 'malloc'
14:48 okkun: static.c:5:22: error: initializer element is not a compile-time constant
14:48 okkun:    static int *pi = malloc(sizeof(int));
14:48 okkun:                     ^~~~~~~~~~~~~~~~~~~
14:49 okkun: a, stdlib.h いれてない
14:49 okkun: いれて再実行
14:49 okkun: $ clang static.c
14:49 okkun: static.c:6:22: error: initializer element is not a compile-time constant
14:49 okkun:    static int *pi = malloc(sizeof(int));
14:49 okkun:                     ^~~~~~~~~~~~~~~~~~~
14:49 okkun: 1 error generated.
14:50 okkun: gccもエラー内容は同様です
14:50 hiroyan: hmhm
14:50 okkun: ちなみにコンパイルしたソースコードは
14:50 okkun: #include <stdio.h>
14:50 okkun: #include <stdlib.h>
14:50 okkun: int main(void)
14:50 okkun: {
14:50 okkun:    static int *pi = malloc(sizeof(int));
14:50 okkun:    return 0;
14:50 okkun: }
14:51 hiroyan: static 外すとエラーで無くなるから、
14:52 hiroyan: static の有無で コンパイラがどういう風にソースを解釈してるか 比較できそう
14:52 hiroyan: > 変数宣言に伴う初期化演算子=と、代入演算子=は、コンパイラの観点からすると異なる情報
14:52 hiroyan: てな話になるんだろうけど
14:52 hiroyan: 。
14:55 hiroyan: あと
14:55 hiroyan: #include <stdio.h>
14:55 hiroyan: #include <stdlib.h>
14:55 hiroyan: int main() {
14:55 hiroyan:        static int *pi;
14:55 hiroyan:        pi  = malloc(sizeof(int));
14:55 hiroyan: }
14:55 hiroyan: でコンパイルしたものを
14:55 hiroyan: $ nm a.out
14:55 hiroyan: 0000000100000f3c s  stub helpers
14:55 hiroyan: 0000000100001048 D _NXArgc
14:55 hiroyan: 0000000100001050 D _NXArgv
14:55 hiroyan: 0000000100001060 D ___progname
14:55 hiroyan: 0000000100000000 A __mh_execute_header
14:55 hiroyan: 0000000100001058 D _environ
14:55 hiroyan:                 U _exit
14:55 hiroyan: 0000000100000f18 T _main
14:55 hiroyan:                 U _malloc
14:55 hiroyan: 0000000100001068 b _pi.3090
14:55 hiroyan: 0000000100001000 s _pvars
14:55 hiroyan:                 U dyld_stub_binder
14:55 hiroyan: 0000000100000edc T start
14:55 hiroyan: で
14:55 hiroyan: 0000000100001068 b _pi.3090
14:56 hiroyan: てな行があって、b の意味が分かると static の意味が分かる (かも
14:56 okkun: おおお
14:57 okkun: nm初めて知りました
14:58 okkun: http://en.wikipedia.org/wiki/Nm_(Unix)
15:00 okkun: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/nm.html
15:00 okkun: Local bss symbol.
15:00 okkun: "bss" (that is, uninitialized data space)
15:00 hiroyan: yes
15:00 hiroyan: http://ja.wikipedia.org/wiki/.bss
15:01 hiroyan: > 通常、bssセクションに割り当てられたメモリはプログラムローダーがプログラムをロードするときに初期化する。main() が実行されるより前にCランタイムシステムがbssセクションにマップされたメモリ領域をゼロで初期化する。ただし、必要時まで0で初期化するのを遅延するというテクニックを使ってOSがbssセクションを効率的
15:01 hiroyan: に実装してもよい。
15:02 hiroyan: こういうことから
15:02 hiroyan: static int *pi = malloc(sizeof(int));
15:03 hiroyan: がコンパイル時に決定できないから 駄目なのかなーと 。
15:05 okkun: 言われてみると
15:05 okkun: mallocは動的割り当てだから
15:05 hiroyan: そそ
15:06 okkun: なるほど…
15:06 hiroyan: static int i = 1 + 1;
15:07 hiroyan: こういうのはコンパイラが勝手に計算してくれてるから出来るんだろうね
15:11 okkun: その場で計算できるものは、コンパイラが自動的にやってくれる
15:11 okkun: 便利…
```