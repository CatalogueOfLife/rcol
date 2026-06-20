# Taxonomic classification (lineage) of a taxon

Returns the ordered parent chain from the root down to the taxon.

## Usage

``` r
clb_classification(id, dataset = "3LXR", .raw = FALSE)
```

## Arguments

- id:

  Taxon id within the dataset.

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of
ancestors, one row per rank, with columns `id`, `name`, `authorship`,
`rank` and `labelHtml`.

## See also

[`clb_usage()`](https://catalogueoflife.github.io/rcol/reference/clb_usage.md),
[`clb_children()`](https://catalogueoflife.github.io/rcol/reference/clb_children.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_classification("4CGXP", dataset = "3LR")
} # }
```
