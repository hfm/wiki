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

 * アドバンテージ
   1. TCPコネクションの接続と切断のオーバヘッドを減らすことで、ルータやホスト (クライアント、サーバ、プロキシ、ゲートウェイ、トンネルやキャッシュ) のCPU時間を節約し、ホスト中のTCPプロトコル操作によるメモリ使用を節約できる（負荷の軽減）。
   1. HTTPリクエスト／レスポンスは接続中にパイプライン化出来る。パイプラインは、クライアントにレスポンスごとの待ちを発生させることなく、複数リクエストを発行させ、1つのTCP接続でより効率良く少ない時間での利用を可能にする。
   1. TCP接続によるパケット数を削減し、ネットワークの輻輳状態を決定する十分な時間があるため、ネットワーク輻輳が軽減される。
   1. TCPコネクションの接続ハンドシェイクの時間消費が無いため、次のリクエストの遅延が減る。
   1. 
HTTP can evolve more gracefully, since errors can be reported without the penalty of closing the TCP connection.
クライアントは
Clients using future versions of HTTP might optimistically try a new feature, but if communicating with an older server, retry with old semantics after an error is reported.

#### TCP接続

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

Persistent Connectionsでは、`Establish TCP Connection`から`Finish TCP Connection`の間に複数のHTTPリクエスト／レスポンスが発生する。