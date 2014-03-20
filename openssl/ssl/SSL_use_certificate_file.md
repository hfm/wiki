# int SSL_use_certificate_file(SSL *ssl, const char *file, int type)

```c
#ifndef OPENSSL_NO_STDIO
int SSL_use_certificate_file(SSL *ssl, const char *file, int type)
	{
	int j;
	BIO *in;
	int ret=0;
	X509 *x=NULL;

	in=BIO_new(BIO_s_file_internal());
	if (in == NULL)
		{
		SSLerr(SSL_F_SSL_USE_CERTIFICATE_FILE,ERR_R_BUF_LIB);
		goto end;
		}

	if (BIO_read_filename(in,file) <= 0)
		{
		SSLerr(SSL_F_SSL_USE_CERTIFICATE_FILE,ERR_R_SYS_LIB);
		goto end;
		}
	if (type == SSL_FILETYPE_ASN1)
		{
		j=ERR_R_ASN1_LIB;
		x=d2i_X509_bio(in,NULL);
		}
	else if (type == SSL_FILETYPE_PEM)
		{
		j=ERR_R_PEM_LIB;
		x=PEM_read_bio_X509(in,NULL,ssl->ctx->default_passwd_callback,ssl->ctx->default_passwd_callback_userdata);
		}
	else
		{
		SSLerr(SSL_F_SSL_USE_CERTIFICATE_FILE,SSL_R_BAD_SSL_FILETYPE);
		goto end;
		}

	if (x == NULL)
		{
		SSLerr(SSL_F_SSL_USE_CERTIFICATE_FILE,j);
		goto end;
		}

	ret=SSL_use_certificate(ssl,x);
end:
	if (x != NULL) X509_free(x);
	if (in != NULL) BIO_free(in);
	return(ret);
	}
#endif
```