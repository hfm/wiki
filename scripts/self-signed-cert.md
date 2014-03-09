# 自己証明書（オレオレ証明書）生成コマンド

## command

```bash
COMMON_NAME=self.signed.cert
openssl req -x509 \
            -days 36500 \
            -newkey rsa:2048 \
            -nodes \
            -out $COMMON_NAME.crt \
            -keyout $COMMON_NAME.key \
            -subj "/C=/ST=/L=/O=/OU=/CN=$COMMON_NAME"
```

## sample

```bash
COMMON_NAME=wiki.hifumi.info
openssl req -x509 \
            -days 36500 \
            -newkey rsa:2048 \
            -nodes \
            -out $COMMON_NAME.crt \
            -keyout $COMMON_NAME.key \
            -subj "/C=JP/ST=Tokyo/L=Shibuya-ku/O=/OU=/CN=$COMMON_NAME"
```


### ref

 * [そこそこ楽にオレオレ証明書を発行する | blog: takahiro okumura](http://blog.hifumi.info/2014/03/06/self-signed-cert/)