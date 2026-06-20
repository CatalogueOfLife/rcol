# Full-text search of name usages

Searches name usages within a dataset (defaults to the latest extended
COL release). The accepted/synonym usage fields are hoisted to top-level
columns; the taxonomic classification and full name object are kept as
list-columns.

## Usage

``` r
clb_usage_search(
  q = NULL,
  dataset = "3LXR",
  rank = NULL,
  status = NULL,
  ...,
  limit = 50L,
  max = limit
)

clb_search(
  q = NULL,
  dataset = "3LXR",
  rank = NULL,
  status = NULL,
  ...,
  limit = 50L,
  max = limit
)
```

## Arguments

- q:

  Free-text query. Optional (omit to browse with filters only).

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- rank:

  Filter by rank (e.g. `"species"`).

- status:

  Filter by taxonomic status (e.g. `"accepted"`, `"synonym"`).

- ...:

  Further query parameters forwarded to the search endpoint (e.g.
  `extinct`, `nomCode`, `minRank`, `maxRank`, `type`).

- limit:

  Page size per request.

- max:

  Maximum number of usages to return. Use `Inf` to fetch all.

## Value

A `clb` object: a list with `$data` (a
[tibble](https://tibble.tidyverse.org/reference/tibble.html) of usages)
and `$meta` (with `total`).

## See also

[`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md),
[`clb_suggest()`](https://catalogueoflife.github.io/rcol/reference/clb_suggest.md),
[`clb_usage()`](https://catalogueoflife.github.io/rcol/reference/clb_usage.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_usage_search("Felidae")
clb_usage_search("Panthera", rank = "species", status = "accepted")
} # }
```
