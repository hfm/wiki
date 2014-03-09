# HyperText Transfer Protocol

 * [RFC 1945 - Hypertext Transfer Protocol -- HTTP/1.0](http://tools.ietf.org/html/rfc1945)
 * [RFC 2616 - Hypertext Transfer Protocol -- HTTP/1.1](http://tools.ietf.org/html/rfc2616)
 * [HTTP/2](http://http2.github.io/)
 * [draft-mbelshe-httpbis-spdy-00 - SPDY Protocol](http://tools.ietf.org/html/draft-mbelshe-httpbis-spdy-00)

## Persistent Connections

持続的接続 (Persistent Connections) 

 * [RFC 2616 # Section 8.1](http://tools.ietf.org/html/rfc2616#section-8.1)
 * [HTTPの教科書 2.7](http://www.amazon.co.jp/exec/obidos/ASIN/B00EESW7K0/hifumiass-22/ref=nosim/)

### RFCより

> a separate TCP connection was established to fetch each URL, increasing the load on HTTP servers and causing congestion on the Internet.
> The use of inline images and other associated data often require a client to make multiple requests of the same server in a short amount of time.

個々のTCP接続がURLごとにフェッチを確立すると、HTTPサーバの通信量が増加し、インターネットの輻輳を引き起こしていた。
画像や他の関連データの利用は、しばしばクライアントに、短い時間のなかで同じサーバへ複数リクエストを要求させている。

### 持続的接続

持続的接続 (Persistent Connections) は、どちらかが明示的に接続切断しない限り、TCP接続を繋ぎ続ける。

### TCP接続

非Persistent Connectionsは1リクエストごとに下記のフローが発生する。

```
+--------+                +--------+
|        |  SYN ------->  |        |
|        |  <--- SYN/ACK  |        | # Establish TCP Connection
|        |  ACK ------->  |        |
|        |                |        |
|        |  REQUEST ===>  |        |
| client |  <== RESPONSE  | server |
|        |                |        |
|        |  <------- FIN  |        |
|        |  ACK ------->  |        | # Finish TCP Connection
|        |  FIN ------->  |        |
|        |  <------- ACK  |        |
+--------+                +--------+
```

Persistent Connectionsでは、`Establish TCP Connection`から`Finish TCP Connection`の間に複数のHTTPリクエスト/レスポンスが発生する。