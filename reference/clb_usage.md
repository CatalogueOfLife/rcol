# Get a name usage (taxon or synonym) by id

Get a name usage (taxon or synonym) by id.

## Usage

``` r
clb_usage(id, dataset = "3LXR", .raw = FALSE)
```

## Arguments

- id:

  Usage id within the dataset.

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A one-row [tibble](https://tibble.tidyverse.org/reference/tibble.html)
with the usage's `id`, `scientific_name`, `authorship`, `rank`,
`status`, `label`, `parent_id` and the full nested `name` as a
list-column.

## See also

[`clb_usage_search()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_search.md),
[`clb_classification()`](https://catalogueoflife.github.io/rcol/reference/clb_classification.md),
[`clb_synonyms()`](https://catalogueoflife.github.io/rcol/reference/clb_synonyms.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_usage("4CGXP", dataset = "3LR")
} # }
```
