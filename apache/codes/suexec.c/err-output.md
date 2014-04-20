# static void err_output(const char *fmt, va_list ap)

## abstract

エラー出力関数。

## argument

### `const char *fmt`

### `va_list ap`

## implementation

```c
static void err_output(const char *fmt, va_list ap)
{
#ifdef AP_LOG_EXEC
    time_t timevar;
    struct tm *lt;

    if (!log) {
        if ((log = fopen(AP_LOG_EXEC, "a")) == NULL) {
            fprintf(stderr, "failed to open log file\n");
            perror("fopen");
            exit(1);
        }
    }

    time(&timevar);
    lt = localtime(&timevar);

    fprintf(log, "[%d-%.2d-%.2d %.2d:%.2d:%.2d]: ",
            lt->tm_year + 1900, lt->tm_mon + 1, lt->tm_mday,
            lt->tm_hour, lt->tm_min, lt->tm_sec);

// log (ストリーム) に対してfmtの書式文字列を出力する。
//出力時にはapのパラメタリストを変換する。
    vfprintf(log, fmt, ap);

    fflush(log);
#endif /* AP_LOG_EXEC */
    return;
}
```