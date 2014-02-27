# Varnishでキャッシュパージ

[How to flush or clear varnish cache](http://www.garron.me/en/bits/how-flush-clear-varnish-cache.html)が見つかったけど、ドキュメント調べたら、このやり方は古いみたい。

> [_varnishd — Varnish version 2.1.5 documentation#management-interface_](https://www.varnish-cache.org/docs/2.1/reference/varnishd.html#management-interface)
> 
> __purge.url regexp__  
> Immediately invalidate all documents whose URL matches the specified regular expression.
> 
> __url.purge regexp__  
Deprecated, see purge.url instead.

というわけで、以下が良さそう。

```
varnishadm -T 127.0.0.1:6082 -S /etc/varnish/secret purge.url .
```

centos6でvarnishを入れると、`/etc/sysconfig/varnishの起動オプションではデフォルトで`-S /etc/varnish/secret`を読み込んで起動するので、varnishadmを操作するときは必ずsecretファイルを読み込むようにしないとauthエラーが出てしまうようだ。