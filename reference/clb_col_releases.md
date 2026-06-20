# List all Catalogue of Life releases

Returns every release (base and extended) derived from the Catalogue of
Life project (dataset key `3`), most useful for discovering historical
annual releases such as `COL23`, `COL24`, `COL25`.

## Usage

``` r
clb_col_releases(project = 3L, ...)
```

## Arguments

- project:

  Integer project key. Defaults to `3` (the Catalogue of Life).

- ...:

  Additional query parameters passed to the `/dataset` endpoint.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of
releases with columns such as `key`, `alias`, `title`, `origin`,
`issued` and `version`.

## Examples

``` r
if (FALSE) { # \dontrun{
clb_col_releases()
} # }
```
