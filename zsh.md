# Zsh

## CentOSに入れる

最新のものを使いたい時にやる．porg前提．

```sh
sudo wget https://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2 -P /usr/local/src/

cd /usr/local/src/
sudo tar jxf zsh-5.0.5.tar.bz2
cd zsh-5.0.5

./configure
make
sudo porg -lp zsh-5.0.5 "make install" 
```