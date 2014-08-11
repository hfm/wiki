# porg

## CentOSに入れる

参考: [[さくらVPS]paco -> porg | りんごの創り方](http://blog.ringo0321.com/?p=153)

```sh
sudo wget http://downloads.sourceforge.net/project/porg/porg-0.7.tar.xz -P /usr/local/src

cd /usr/local/src
sudo tar Jxf porg-0.7.tar.xz
cd porg-0.7

# GUIモジュールは要らないので省く
./configure --disable-grop
make
sudo make install
```