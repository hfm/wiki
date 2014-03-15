# OpenSSL

## Key Algorithm

opensslの鍵アルゴリズムにはRSA、DSA、ECDSAがある。
SSL鍵はみなRSAが使われている。DSAは鍵長が1024bitsまでだし、ECDSAはまだそんなに広くサポートされていない。

デフォルトの鍵長は安全ではないから、鍵長は明示的に調節すべきである。
今現在だと2014bitsが安全だと考えられている。
本にはデフォルトで512bitsになってると書かれているが、これはバージョンやパッケージ管理ツールの仕様にもよるだろう。

## Tips
モジラの証明書のフォーマットをPEMフォーマットに変換するツールが、perlとgolangで開発されている。

## Words
### trust store
信頼できるルート証明書を総称する言葉。

## Commands
### Self-signed cert

```sh
COMMON_NAME=wiki.hifumi.info
openssl req -x509 \
            -days 36500 \
            -newkey rsa:2048 \
            -nodes \
            -out $COMMON_NAME.crt \
            -keyout $COMMON_NAME.key \
            -subj "/C=JP/ST=Tokyo/L=Shibuya-ku/O=/OU=/CN=$COMMON_NAME"
```