# Parse scientific names

Atomises one or more scientific names into their nomenclatural
components (genus, epithets, rank, authorship, ...) using the GBIF name
parser exposed by ChecklistBank.

## Usage

``` r
clb_parse_name(name, authorship = NULL, rank = NULL, code = NULL, .raw = FALSE)
```

## Arguments

- name:

  A character vector of scientific names (may include authorship).

- authorship:

  Optional authorship string (used when a single `name` is supplied
  without its author).

- rank:

  Optional rank hint (e.g. `"species"`).

- code:

  Optional nomenclatural code hint.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with one
row per input name and columns such as `scientificName`, `authorship`,
`rank`, `genus`, `specificEpithet`, `type` and `parsed`. Nested fields
(e.g. `combinationAuthorship`) are returned as list-columns.

## See also

[`clb_parse()`](https://catalogueoflife.github.io/rcol/reference/clb_parse.md),
[`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_parse_name("Abies alba Mill.")
clb_parse_name(c("Panthera leo (Linnaeus, 1758)", "Bellis perennis L."))
} # }
```
