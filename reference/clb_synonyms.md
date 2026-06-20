# Synonyms of a taxon

Synonyms of a taxon.

## Usage

``` r
clb_synonyms(id, dataset = "3LXR", .raw = FALSE)
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
synonym usages with a `synonym_type` column (`"homotypic"` or
`"heterotypic"`) and the usual flattened usage columns. Zero rows when
the taxon has no synonyms.

## See also

[`clb_usage()`](https://catalogueoflife.github.io/rcol/reference/clb_usage.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_synonyms("6DBT", dataset = "3LR")
} # }
```
