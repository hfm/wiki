# ImageMagickのコマンド

`yum install ImageMagick`で入ったコマンド一覧。

```console
$ rpm -ql ImageMagick | grep bin
/usr/bin/animate
/usr/bin/compare
/usr/bin/composite
/usr/bin/conjure
/usr/bin/convert
/usr/bin/display
/usr/bin/identify
/usr/bin/import
/usr/bin/mogrify
/usr/bin/montage
/usr/bin/stream
```

## animate
## compare
## composite
## conjure
## convert
## display
## identify

> _man 1 identify_
> 
> describes the format and characteristics of one or more image files.

### -list

ImageMagickがサポートする様々な属性を出力する。
delegateとかmoduleとかresourceとか、いろいろ吐き出せる。

#### format

画像フォーマットの出力が出来る。

```console
$ identify -list format | head
   Format  Module    Mode  Description
-------------------------------------------------------------------------------
        A* RAW       rw+   Raw alpha samples
       AI  PDF       rw-   Adobe Illustrator CS2
      ART* ART       rw-   PFS: 1st Publisher Clip Art
      ARW  DNG       r--   Sony Alpha Raw Image Format
      AVI* AVI       r--   Microsoft Audio/Visual Interleaved
      AVS* AVS       rw+   AVS X image
        B* RAW       rw+   Raw blue samples
      BGR* RGB       rw+   Raw blue, green, and red samples
```

#### color

blackやwhiteのような色名と、対応するrgb等を出力する。

```console
$ identify -list color | head

Path: /usr/share/ImageMagick-6.5.4/config/colors.xml

Name                  Color                                         Compliance
-------------------------------------------------------------------------------
AliceBlue             rgb(240,248,255)                              SVG X11 XPM
AntiqueWhite          rgb(250,235,215)                              SVG X11 XPM
AntiqueWhite1         rgb(255,239,219)                              X11
AntiqueWhite2         rgb(238,223,204)                              X11
AntiqueWhite3         rgb(205,192,176)                              X11
```

## import
## mogrify
## montage
## stream