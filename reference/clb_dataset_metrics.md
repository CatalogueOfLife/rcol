# Dataset metrics

Returns the record counts of a dataset's most recent successful import
(or, for releases, the release build): numbers of names, taxa, synonyms,
vernacular names, distributions, references and so on, including by-rank
and by-gazetteer breakdowns.

## Usage

``` r
clb_dataset_metrics(dataset = "3LXR", .raw = FALSE)
```

## Arguments

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A one-row [tibble](https://tibble.tidyverse.org/reference/tibble.html)
of metrics. Breakdown maps such as `usagesByRankCount` are returned as
list-columns. `NULL` (with a message) if the dataset has no import yet.

## See also

[`clb_dataset()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset.md),
[`clb_usage_metrics()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_metrics.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_dataset_metrics()         # latest extended COL release
clb_dataset_metrics("COL25")
} # }
```
