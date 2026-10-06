# Full information about a name usage

Fetches the complete `UsageInfo` document for a usage in one request:
the usage itself together with its classification, synonymy, vernacular
names, distributions, media, references, type material and other related
data, as shown on a ChecklistBank taxon page. Works for accepted taxa
and synonyms.

## Usage

``` r
clb_usage_info(id, dataset = "3LXR", .raw = FALSE)
```

## Arguments

- id:

  Usage id within the dataset.

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- .raw:

  Return the raw parsed JSON instead of a `clb_usage_info` list?

## Value

A `clb_usage_info` object: a named list whose elements are always
present, empty when the API returns no data for them:

- `usage`: a one-row
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) as
  returned by
  [`clb_usage()`](https://catalogueoflife.github.io/rcol/reference/clb_usage.md).

- `group`: the informal taxonomic group, e.g. `"chordates"`.

- `classification`, `synonyms`, `vernacular_names`, `distributions`,
  `media`, `name_relations`, `properties`, `concept_relations`,
  `species_interactions`, `estimates`, `type_material`: tibbles, one row
  per record. `synonyms` and `distributions` are shaped as in
  [`clb_synonyms()`](https://catalogueoflife.github.io/rcol/reference/clb_synonyms.md)
  and
  [`clb_distribution()`](https://catalogueoflife.github.io/rcol/reference/clb_distribution.md).

- `references`, `names`, `taxa`, `decisions`: tibbles of the records
  referred to by id from the other elements.

- `published_in`, `source`, `verbatim`: nested lists, or `NULL` when
  absent.

The usage's treatment document is not included; use `.raw = TRUE` to get
it.

## See also

[`clb_usage()`](https://catalogueoflife.github.io/rcol/reference/clb_usage.md),
[`clb_classification()`](https://catalogueoflife.github.io/rcol/reference/clb_classification.md),
[`clb_synonyms()`](https://catalogueoflife.github.io/rcol/reference/clb_synonyms.md),
[`clb_vernacular()`](https://catalogueoflife.github.io/rcol/reference/clb_vernacular.md)

## Examples

``` r
if (FALSE) { # \dontrun{
info <- clb_usage_info("6JBVG", dataset = "3LR")
info
info$vernacular_names
} # }
```
