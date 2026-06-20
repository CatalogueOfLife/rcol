# Metrics for a taxon

Returns subtree metrics for a taxon: tree depth, child and species
counts, and a by-rank breakdown of descendants.

## Usage

``` r
clb_usage_metrics(id, dataset = "3LXR", .raw = FALSE)
```

## Arguments

- id:

  Taxon id within the dataset.

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A one-row [tibble](https://tibble.tidyverse.org/reference/tibble.html)
of metrics. Map fields such as `taxaByRankCount` are returned as
list-columns.

## See also

[`clb_dataset_metrics()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset_metrics.md),
[`clb_children()`](https://catalogueoflife.github.io/rcol/reference/clb_children.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_usage_metrics("4CGXP", dataset = "3LR")
} # }
```
