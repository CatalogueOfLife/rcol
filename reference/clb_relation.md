# Taxon concept relations of a taxon

Relations between this taxon concept and others, e.g. `"equals"`,
`"includes"` or `"overlaps"`.

## Usage

``` r
clb_relation(id, dataset = "3LXR", .raw = FALSE)
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
relations with columns such as `type`, `relatedTaxonId` and
`referenceId`. Zero rows when the taxon has no concept relations.

## See also

[`clb_interaction()`](https://catalogueoflife.github.io/rcol/reference/clb_interaction.md),
[`clb_usage_info()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_info.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_relation("4CGXP", dataset = "3LR")
} # }
```
