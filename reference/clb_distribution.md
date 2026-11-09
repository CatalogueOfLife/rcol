# Distributions of a taxon

Distributions of a taxon

## Usage

``` r
clb_distribution(id, dataset = "3LXR", citations = TRUE, .raw = FALSE)
```

## Arguments

- id:

  Taxon id within the dataset.

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- citations:

  Look up the citation of each distinct `referenceId` and add it as
  `reference_citation`? This costs one extra request per distinct
  reference.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of
distribution records. The nested area is returned as `area_gazetteer`,
`area_id` and `area_name` columns, plus `country_code`, the ISO 3166-1
country derived from ISO area ids (`BE` for `BE-VLG`; `NA` for other
gazetteers such as TDWG or free text). The remaining columns are fields
such as `establishmentMeans`, `degreeOfEstablishment`, `pathway`,
`threatStatus`, `year`, `referenceId` and, with `citations = TRUE`,
`reference_citation`. Zero rows when the taxon has no distributions.

Imported Darwin Core distributions keep only the year of `dwc:eventDate`
(`2014/` becomes `year` 2014), and `dwc:occurrenceStatus` is not part of
the ColDP model. The original values are in the verbatim record of each
row (`verbatimKey`), available from the API at
`dataset/{key}/verbatim/{verbatimKey}`.

## See also

[`clb_usage_info()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_info.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_distribution("4CGXP", dataset = "3LR")
} # }
```
