# Species interactions of a taxon

Species interactions of a taxon

## Usage

``` r
clb_interaction(id, dataset = "3LXR", .raw = FALSE)
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
interactions with columns such as `type`, `relatedTaxonId`,
`relatedTaxonScientificName` and `referenceId`. Zero rows when the taxon
has no interactions.

## See also

[`clb_relation()`](https://catalogueoflife.github.io/rcol/reference/clb_relation.md),
[`clb_usage_info()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_info.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_interaction("4CGXP", dataset = "3LR")
} # }
```
