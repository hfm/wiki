# Strace

## Options

### -f

> Trace child processes as they are created by currently traced processes as a result of the fork(2) system call.
> 
> On non-Linux platforms the new process is attached to as soon as its pid is known (through the return value of fork(2) in the parent process). This means that such children may run uncontrolled  for  a  while (especially in the case of a vfork(2)), until the parent is scheduled again to complete its (v)fork(2) call.  On Linux the child is traced from its first instruction with no delay. If the parent process decides to wait(2) for a child that is currently being traced, it is suspended until an appropriate child process either terminates or incurs a signal that would cause it to terminate (as determined from the child’s current signal disposition).
> 
> On SunOS 4.x the tracing of vforks is accomplished with some dynamic linking trickery.

対象プロセスからfork(2)で生成された子プロセスもトレースする．

### -ff 

> If the -o filename option is in effect, each processes trace is written to filename.pid where pid is the numeric process id of each process. This is incompatible with -c, since no per-process counts are kept.

`-o filename`オプションが有効の場合，プロセスのトレースごとに`filename.pid` (各プロセスのプロセスID番号) が書き込まれる．
プロセスごとのカウント数が保持されず，このオプションは`-c`と非互換である．

### -s strsize

> Specify the maximum string size to print (the default is 32). Note that filenames are not considered strings and are always printed in full.

出力されるstringサイズの最大値を指定する（デフォルトは32）．
ファイル名は文字列に考慮されず，常に完全に出力されることに注意．

### -p pid

> Attach to the process with the process ID pid and begin tracing. The trace may be terminated at any time by a keyboard interrupt signal (CTRL-C). strace will respond by detaching itself from the traced process(es) leaving it (them) to continue running. Multiple -p options can be used to attach to up to 32 processes in addition to command (which is optional if at least one -p option is given).

指定したPIDのプロセスにアタッチし，トレースを開始する．

### -e expr

```
[qualifier=][!]value1[,value2]...
```

`qualifier`には`trace`, `abbrev`, `verbose`, `raw`, `signal`, `read`, `write`等が入る．

`-e trace=open`のように書く．`-eopen`と省略も可能．

#### -e trace=