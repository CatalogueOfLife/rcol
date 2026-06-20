# Resolve a Catalogue of Life release

The Catalogue of Life is published as a managed project (dataset key
`3`) from which immutable *releases* are derived. There are two cadences
(monthly and annual) and two flavours (a *base* release and an
*extended* release `XR`, which merges additional external data). This
helper returns the dataset identifier (an alias such as `"3LXR"` or
`"COL25"`) you can pass to any `dataset =` argument in this package.

## Usage

``` r
clb_col_release(cadence = c("monthly", "annual"), extended = FALSE)
```

## Arguments

- cadence:

  Either `"monthly"` (the default) or `"annual"`.

- extended:

  Logical. Return the extended release (`XR`) instead of the base
  release? Defaults to `FALSE`.

## Value

A length-one character vector with the release alias, or `NA` (with a
warning) when the requested release has not been published yet – as is
currently the case for the annual extended release.

## Details

The monthly releases have stable magic aliases that always point at the
most recent one:

- `"3LR"` – latest monthly **base** release

- `"3LXR"` – latest monthly **extended** release

Annual releases use a `COL<YY>` alias (e.g. `"COL25"`, and `"COL25 XR"`
for the extended variant). The latest one is discovered from the list of
all releases of project `3`.

## See also

[`clb_col_releases()`](https://catalogueoflife.github.io/rcol/reference/clb_col_releases.md)
for the full list of releases.

## Examples

``` r
if (FALSE) { # \dontrun{
clb_col_release("monthly")                  # "3LR"
clb_col_release("monthly", extended = TRUE) # "3LXR"
clb_col_release("annual")                   # e.g. "COL25"
} # }
```
