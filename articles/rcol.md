# Getting started with rcol

`rcol` wraps the [ChecklistBank](https://www.checklistbank.org) API to
give R users idiomatic access to the [Catalogue of
Life](https://www.catalogueoflife.org) (COL) and every other public
dataset in ChecklistBank.

``` r

library(rcol)
```

## Two function families

Most functions come in two forms:

- **`clb_*()`** take a `dataset =` argument and work against any
  dataset.
- **`col_*()`** drop that argument and always target the latest extended
  COL release. The `"3LXR"` alias is resolved once to its integer
  dataset key and cached for the session via
  [`col_key()`](https://catalogueoflife.github.io/rcol/reference/col_key.md),
  so long-running work is not disrupted by a new release being published
  midway. Use
  [`col_refresh()`](https://catalogueoflife.github.io/rcol/reference/col_refresh.md)
  to deliberately re-pin to the newest release.

``` r

col_key()      # the pinned integer dataset key of the latest extended release
col_refresh()  # re-resolve to the newest release
```

## Choosing a dataset

Almost every function takes a `dataset =` argument identifying which
checklist to work against. You can pass:

- a numeric dataset key, e.g. `3` (the COL project),
- a dataset alias such as `"COL25"` (the 2025 annual release), or
- one of the *magic* COL release aliases that always resolve to the most
  recent release.

The COL is published in two cadences (monthly and annual) and two
flavours: a **base** release and an **extended** release (`XR`) that
merges in additional data.
[`clb_col_release()`](https://catalogueoflife.github.io/rcol/reference/clb_col_release.md)
returns the right identifier:

``` r

clb_col_release("monthly")                  # "3LR"   latest monthly base release
clb_col_release("monthly", extended = TRUE) # "3LXR"  latest monthly extended release
clb_col_release("annual")                   # e.g. "COL25"

# Every release, e.g. to find historical annual editions
clb_col_releases()
```

The package default is `"3LXR"`, the latest monthly extended release.

## Matching names

[`col_match()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
returns the single best match against the latest COL release — the COL
analogue of GBIF’s name backbone matching. The match is done by the
ChecklistBank API and returns a tidy one-row tibble with the matched
usage, the match type and the taxonomic classification:

``` r

col_match("Panthera leo")
col_match("Abies alba", rank = "species", code = "botanical")
```

Use
[`col_match_verbose()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
to see all candidate usages, and
[`col_match_checklist()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
to match a whole vector or data frame in parallel (input columns are
echoed back with a `verbatim_` prefix):

``` r

col_match_verbose("Oenanthe")

col_match_checklist(c("Panthera leo", "Bufo bufo", "Abies alba"))
```

To match against a particular dataset rather than the latest COL
release, use
[`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md)
with a `dataset =` key or alias:

``` r

clb_match("Felis catus", dataset = "COL25")
clb_match("Bellis perennis", dataset = 2099)
```

## Parsing

The ChecklistBank parsers are exposed too — the scientific name parser
and all the controlled-value parsers:

``` r

clb_parse_name("Abies alba Mill.")

clb_parsers()
clb_parse("rank", c("spec", "fam.", "ssp"))
```

## Datasets

``` r

clb_dataset_search("mammal")
clb_dataset("3LXR")
clb_dataset_metrics("COL25")
```

## Taxa and the tree

Using the `col_*()` shortcuts against the latest COL release:

``` r

# Look up a usage and its context
col_usage("4CGXP")
col_classification("4CGXP")
col_synonyms("6DBT")
col_vernacular(id = "4CGXP")

# Navigate the tree
roots <- col_tree()
col_children(roots$id[1])

# Full-text search and metrics
col_usage_search("Felidae")
col_suggest("Panth")
col_usage_metrics("4CGXP")
```

The dataset-scoped equivalents take a `dataset =` argument, e.g.
`clb_usage("4CGXP", dataset = "COL25")` or
`clb_tree(dataset = "COL25")`.

## Pointing at another server

Set `CLB_BASE_URL` to target a different ChecklistBank deployment, such
as the development API:

``` r

Sys.setenv(CLB_BASE_URL = "https://api.dev.checklistbank.org")
```
