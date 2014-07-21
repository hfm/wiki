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

> If  the  -o  filename option is in effect, each processes trace is written to filename.pid where pid is the numeric process id of each process.  This is incompatible with -c, since no per-process counts are kept.
