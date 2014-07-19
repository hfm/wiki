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
