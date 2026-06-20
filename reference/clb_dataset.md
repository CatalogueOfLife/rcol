# Get dataset metadata

Retrieves the full metadata record for a single dataset.

## Usage

``` r
clb_dataset(key, .raw = FALSE)
```

## Arguments

- key:

  Dataset key or alias (e.g. `3`, `"3LXR"`, `"COL25"`).

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A one-row [tibble](https://tibble.tidyverse.org/reference/tibble.html)
of dataset metadata (nested fields such as `contact` or `creator` are
list-columns), or the raw list when `.raw = TRUE`.

## See also

[`clb_dataset_search()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset_search.md),
[`clb_dataset_metrics()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset_metrics.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_dataset("3LXR")
clb_dataset(3)
} # }
```
