# Distributions of a taxon

Distributions of a taxon

## Usage

``` r
clb_distribution(id, dataset = "3LXR", .raw = FALSE)
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
distribution records. The nested area is returned as `area_gazetteer`,
`area_id` and `area_name` columns, alongside fields such as
`establishmentMeans`, `threatStatus` and `referenceId`. Zero rows when
the taxon has no distributions.

## See also

[`clb_usage_info()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_info.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_distribution("4CGXP", dataset = "3LR")
} # }
```
