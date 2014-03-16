# SSLerr(f,r)

crypto/err/err.h

```c
#define SSLerr(f,r)  ERR_PUT_error(ERR_LIB_SSL,(f),(r),__FILE__,__LINE__)
```

## define methods

 * `ERR_PUT_error(ERR_LIB_SSL,(f),(r),__FILE__,__LINE__)`