# Vernacular (common) names

Looks up vernacular names either for a single taxon (when `id` is given)
or across a dataset by free-text query.

## Usage

``` r
clb_vernacular(
  id = NULL,
  dataset = "3LXR",
  q = NULL,
  lang = NULL,
  ...,
  limit = 50L,
  max = limit,
  .raw = FALSE
)
```

## Arguments

- id:

  Optional taxon id. When supplied, returns the vernacular names of that
  taxon; otherwise performs a dataset-wide vernacular search using `q`.

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- q:

  Free-text query for the dataset-wide search (ignored when `id` is
  supplied).

- lang:

  Optional ISO language filter (e.g. `"eng"`, `"deu"`).

- ...:

  Further query parameters.

- limit:

  Page size for the dataset-wide search.

- max:

  Maximum rows for the dataset-wide search.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of
vernacular names with columns such as `name`, `latin`, `language` and
`taxonID`.

## Examples

``` r
if (FALSE) { # \dontrun{
clb_vernacular(id = "4CGXP", dataset = "3LR")
clb_vernacular(q = "lion", lang = "eng")
} # }
```
