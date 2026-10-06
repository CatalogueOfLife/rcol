# Properties of a taxon

Free-form taxon properties such as traits or descriptive facts.

## Usage

``` r
clb_property(id, dataset = "3LXR", .raw = FALSE)
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
properties with columns such as `property`, `value`, `referenceId` and
`ordinal`. Zero rows when the taxon has no properties.

## See also

[`clb_usage_info()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_info.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_property("4CGXP", dataset = "3LR")
} # }
```
