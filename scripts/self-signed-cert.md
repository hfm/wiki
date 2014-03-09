# 自己証明書（オレオレ証明書）生成コマンド

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