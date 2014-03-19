# SSLerr(f,r)

## defined

 * `crypto/err/err.h`

## codes

```c
#define SSLerr(f,r)  ERR_PUT_error(ERR_LIB_SSL,(f),(r),__FILE__,__LINE__)
```

## methods

 * [ERR_PUT_error(ERR_LIB_SSL,(f),(r),__FILE__,__LINE__)](ERR_PUT_error)