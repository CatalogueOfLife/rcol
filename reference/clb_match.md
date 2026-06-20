# Match a scientific name against a ChecklistBank dataset

Looks up the single best-matching name usage for a scientific name in a
dataset, defaulting to the latest monthly extended Catalogue of Life
release (`"3LXR"`). This is the Catalogue of Life analogue of GBIF's
name backbone matching.

## Usage

``` r
clb_match(
  name,
  authorship = NULL,
  rank = NULL,
  code = NULL,
  dataset = "3LXR",
  server = NULL,
  .raw = FALSE
)
```

## Arguments

- name:

  Scientific name to match. May include the authorship, or supply it
  separately via `authorship`.

- authorship:

  Optional authorship string.

- rank:

  Optional rank to disambiguate (e.g. `"species"`, `"genus"`).

- code:

  Optional nomenclatural code (`"zoological"`, `"botanical"`,
  `"bacterial"`, `"virus"`, ...).

- dataset:

  Dataset key or alias to match against. Defaults to `"3LXR"`. See
  [`clb_col_release()`](https://catalogueoflife.github.io/rcol/reference/clb_col_release.md)
  for the COL release aliases.

- server:

  Optional base URL of an alternative matching service, e.g. a locally
  running dockerized matching container (`"http://localhost:8080"`).
  Overrides `CLB_BASE_URL` for this call.

- .raw:

  Return the raw parsed JSON response instead of a tibble?

## Value

A one-row [tibble](https://tibble.tidyverse.org/reference/tibble.html)
with the match outcome (`match`, `match_type`), the matched usage
(`usage_id`, `name`, `authorship`, `rank`, `status`, ...) and a
`classification` list-column. When nothing matches, `match` is `FALSE`
and the usage columns are `NA`.

## See also

[`clb_match_verbose()`](https://catalogueoflife.github.io/rcol/reference/clb_match_verbose.md),
[`clb_match_checklist()`](https://catalogueoflife.github.io/rcol/reference/clb_match_checklist.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_match("Panthera leo")
clb_match("Abies alba", rank = "species", code = "botanical")
clb_match("Felis catus", dataset = "COL25")
} # }
```
