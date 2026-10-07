# Get a name usage (taxon or synonym) by id

Get a name usage (taxon or synonym) by id

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
`status`, `label`, `parent_id`, `extinct`, the accepted usage of a
synonym (`accepted_id`, `accepted_name`), its provenance (`origin`,
`dataset_key`, `sector_key`, `sector_mode`, `verbatim_key`,
`verbatim_source_key`, `merged`), further usage fields (`name_phrase`,
`according_to`, `according_to_id`, `link`, `remarks`, `scrutinizer`,
`scrutinizer_id`, `scrutinizer_date`, `temporal_range_start`,
`temporal_range_end`, `ordinal`), the list-columns `identifier`,
`reference_ids` and `environments`, and the full nested `name` as a
list-column. Fields that do not apply, such as `scrutinizer` for a
synonym, are `NA`.

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
