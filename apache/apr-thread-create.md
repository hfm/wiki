apacheをgracefulするとたまにこんなエラーが出る。

```
Cannot allocate memory: apr_thread_create: unable to create worker thread
```

見ての通りメモリ不足でワーカスレッド生やせないよというエラー。
このエラーが出るときは、だいたい次のイベントが発生した後とかに怒るらしい。

> [___apr_thread_create() failures with IBM HTTP Server___](https://publib.boulder.ibm.com/httpserv/ihsdiag/apr_thread_create.html)
> 
> * MaxClients or ThreadsPerChild has been increased.
> * New instances of IHS are put into service
> * New colocated instances of WebSphere are put into service.
> * Operating system release is upgraded.

「MaxClients or ThreadsPerChild has been increased.」はホスティングサービスではよくありそう。