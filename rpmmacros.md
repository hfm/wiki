# .rpmmacros

[いまさら聞けないrpmbuildことはじめ - blog.tnmt.info](http://blog.tnmt.info/2011/04/29/rpmbuild-for-beginner/)とかに出てくる`.rpmmacros`の設定がよく分かってないのでメモする。

## %{_topdir}

[RPM directory macros](https://fedoraproject.org/wiki/Packaging:RPMMacros?rd=Packaging/RPMMacros#RPM_directory_macros)という項目がある。
以下のように書かれている。

```spec
%{_topdir}            %{getenv:HOME}/rpmbuild
%{_builddir}          %{_topdir}/BUILD
%{_rpmdir}            %{_topdir}/RPMS
%{_sourcedir}         %{_topdir}/SOURCES
%{_specdir}           %{_topdir}/SPECS
%{_srcrpmdir}         %{_topdir}/SRPMS
%{_buildrootdir}      %{_topdir}/BUILDROOT
```

そして`%{_topdir}`自身は`$HOME`を指している．
この変数を中心としてBUILDやSPECSといったディレクトリを指定しているらしい．

## %debug_package

> #### [debuginfo packages](http://cholla.mmto.org/computers/linux/rpm/building.html)
> 
> Somewhere along the way, rpmbuild began spitting out "debuginfo" packages. (This seemed to happen in late 2008 with the advent of Fedora 9). Although these now get generated, I have never been sure why or what they are all about. Here is the story.
> 
> The Gnu debugger (gdb) was enhanced to allow debugging information to be read from separate files (it used to be the case that an executable had to be specially built with certain compiler switches to include debug information). The rpmbuild program (actually the RPM macros) has been set up to generate this information and place it into a separate "debuginfo" package whenever a package is built. Details about how this is done may be found in the files in /usr/lib/rpm, in particular /usr/lib/rpm/find-debuginfo.sh.
> 
> This behavior can be suppressed by adding the following to your ~/.rpmmacros file:
> 
> %debug_package %{nil}
> (The string %define debug_package %{nil} is mentioned in some documentation, but that is apparently in error).

## %_smp_mflags

- [_smp_mflags - サトルサトラレ](http://d.hatena.ne.jp/satoru739/20111121/1321940585)