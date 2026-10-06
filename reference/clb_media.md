# Media of a taxon

Media of a taxon

## Usage

``` r
clb_media(id, dataset = "3LXR", .raw = FALSE)
```

## Arguments

- id:

  Taxon id within the dataset.

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of media
items with columns such as `url`, `thumbnail`, `type`, `title`,
`license` and `capturedBy`. Zero rows when the taxon has no media.

## See also

[`clb_usage_info()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_info.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_media("4CGXP", dataset = "3LR")
} # }
```
