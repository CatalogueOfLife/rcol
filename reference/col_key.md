# The pinned Catalogue of Life release key

Resolves the latest monthly extended Catalogue of Life release (the
`"3LXR"` alias) to its concrete integer dataset key and caches it for
the rest of the session. All `col_*()` convenience functions use this
key, so a new release published mid-session will not silently change the
data you are working against during a long-running job. Call
[`col_refresh()`](https://catalogueoflife.github.io/rcol/reference/col_refresh.md)
to re-resolve.

## Usage

``` r
col_key(refresh = FALSE)
```

## Arguments

- refresh:

  Logical. Force re-resolution of the latest release even if a key is
  already cached.

## Value

The integer dataset key of the pinned COL extended release.

## See also

[`col_refresh()`](https://catalogueoflife.github.io/rcol/reference/col_refresh.md),
[`clb_col_release()`](https://catalogueoflife.github.io/rcol/reference/clb_col_release.md)

## Examples

``` r
if (FALSE) { # \dontrun{
col_key()
} # }
```
