# Search datasets in ChecklistBank

Full-text and faceted search across all public datasets in
ChecklistBank. Uses the light dataset representation (`full = FALSE`)
for speed.

## Usage

``` r
clb_dataset_search(
  q = NULL,
  type = NULL,
  origin = NULL,
  ...,
  limit = 50L,
  max = limit
)
```

## Arguments

- q:

  Free-text query (matches title, alias, description, ...). Optional.

- type:

  Filter by dataset type (e.g. `"taxonomic"`, `"nomenclatural"`).

- origin:

  Filter by origin (e.g. `"external"`, `"project"`, `"release"`,
  `"xrelease"`).

- ...:

  Further query parameters forwarded to the `/dataset` endpoint (e.g.
  `contributesTo`, `code`, `gbifKey`).

- limit:

  Page size per request.

- max:

  Maximum number of datasets to return. Use `Inf` to fetch all.

## Value

A `clb` object whose `$data` is a
[tibble](https://tibble.tidyverse.org/reference/tibble.html) of
datasets, one row each, with columns such as `key`, `alias`, `title`,
`type`, `origin`, `license` and `issued`.

## See also

[`clb_dataset()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset.md),
[`clb_dataset_metrics()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset_metrics.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_dataset_search("mammal")
clb_dataset_search(origin = "release", max = 1000)
} # }
```
