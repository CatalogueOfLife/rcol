# Autocomplete suggestions for name usages

Fast prefix-based suggestions, suitable for type-ahead lookups.

## Usage

``` r
clb_suggest(q, dataset = "3LXR", ..., .raw = FALSE)
```

## Arguments

- q:

  Partial name to complete.

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- ...:

  Further query parameters (e.g. `rank`, `status`).

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of
suggestions with columns such as `suggestion`, `usageId`, `rank`,
`status` and `group`.

## See also

[`clb_usage_search()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_search.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_suggest("Panth")
} # }
```
