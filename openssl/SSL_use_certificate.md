# `int SSL_use_certificate(SSL *ssl, X509 *x)`

## defined

 * `ssl/ssl_rsa.c`

## codes

```c
int SSL_use_certificate(SSL *ssl, X509 *x)
	{
	if (x == NULL)
		{
		SSLerr(SSL_F_SSL_USE_CERTIFICATE,ERR_R_PASSED_NULL_PARAMETER);
		return(0);
		}
	if (!ssl_cert_inst(&ssl->cert))
		{
		SSLerr(SSL_F_SSL_USE_CERTIFICATE,ERR_R_MALLOC_FAILURE);
		return(0);
		}
	return(ssl_set_cert(ssl->cert,x));
	}
```

## variables

 * `SSL *ssl`
 * `X509 *x`
 * `SSL_F_SSL_USE_CERTIFICATE`
 * `ERR_R_MALLOC_FAILURE`

## call methods

 * [[SSLerr(f,r)|SSLerr]]
 * `ssl_cert_inst()`
 * `ssl_set_cert()`