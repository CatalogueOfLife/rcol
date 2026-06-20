# Re-pin the Catalogue of Life release

Re-resolves the latest extended COL release and updates the key cached
by
[`col_key()`](https://catalogueoflife.github.io/rcol/reference/col_key.md).
Use this to pick up a newly published release within a running session.

## Usage

``` r
col_refresh()
```

## Value

The integer dataset key of the newly pinned release, invisibly.

## See also

[`col_key()`](https://catalogueoflife.github.io/rcol/reference/col_key.md)

## Examples

``` r
if (FALSE) { # \dontrun{
col_refresh()
} # }
```
