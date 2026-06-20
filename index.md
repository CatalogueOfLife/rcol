# rcol

`rcol` is an R client for the [Catalogue of
Life](https://www.catalogueoflife.org) via the
[ChecklistBank](https://www.checklistbank.org) API
(<https://api.checklistbank.org>). It lets you match scientific names,
look up datasets, taxa and name usages, navigate the taxonomic tree, and
run the ChecklistBank parsers — against **any** public dataset in
ChecklistBank or the latest Catalogue of Life release. It is modelled on
the conventions of [`rgbif`](https://docs.ropensci.org/rgbif/) and
[`taxadb`](https://docs.ropensci.org/taxadb/).

There are two parallel families of functions:

- **`clb_*()`** work against **any** dataset and take a `dataset =`
  argument.
- **`col_*()`** are convenience siblings that always target the **latest
  extended Catalogue of Life release** and drop the `dataset` argument.
  On first use the release alias `"3LXR"` is resolved to its concrete
  integer key and pinned for the rest of the session (via
  [`col_key()`](https://catalogueoflife.github.io/rcol/reference/col_key.md)),
  so a release published mid-session never changes the data under a
  long-running job. Call
  [`col_refresh()`](https://catalogueoflife.github.io/rcol/reference/col_refresh.md)
  to pick up a new release on purpose.

## Installation

Install the development version from GitHub:

``` r

# install.packages("pak")
pak::pak("CatalogueOfLife/rcol")

# or
# install.packages("remotes")
remotes::install_github("CatalogueOfLife/rcol")
```

Documentation is published at <https://catalogueoflife.github.io/rcol/>.

## Quick start

``` r

library(rcol)

# Match a name against the latest Catalogue of Life release
col_match("Panthera leo")

# Disambiguate with rank and nomenclatural code
col_match("Abies alba", rank = "species", code = "botanical")

# See all candidate matches, not just the best one
col_match_verbose("Oenanthe")

# Match many names at once (issued in parallel)
col_match_checklist(c("Panthera leo", "Bufo bufo", "Abies alba"))

# Parse a scientific name into its components
clb_parse_name("Abies alba Mill.")
```

To match against a specific dataset instead of the latest COL release,
use the `clb_*()` form with a `dataset =` key or alias:

``` r

clb_match("Felis catus", dataset = "COL25")          # the 2025 annual release
clb_match("Macrocystis pyrifera", dataset = 2099)    # any public dataset by key
```

## Catalogue of Life releases

The Catalogue of Life is published in two cadences (monthly and annual)
and two flavours (a base release and an extended release `XR`). Every
`clb_*()` function takes a `dataset =` argument; helpful aliases resolve
to the latest of each:

``` r

clb_col_release("monthly")                  # "3LR"   latest monthly base
clb_col_release("monthly", extended = TRUE) # "3LXR"  latest monthly extended
clb_col_release("annual")                   # e.g. "COL25"

clb_usage_search("Felidae", dataset = "COL25")
```

## Datasets, taxa & tree

The `col_*()` shortcuts work against the latest COL release:

``` r

# Search datasets across all of ChecklistBank
clb_dataset_search("reptile")

# Walk the COL tree
roots <- col_tree()
col_children(roots$id[1])

# Classification, synonyms and vernaculars of a taxon
col_classification("4CGXP")
col_synonyms("6DBT")
col_vernacular(id = "4CGXP")

# Full-text search and metrics
col_usage_search("Felidae")
col_dataset_metrics()
col_usage_metrics("4CGXP")
```

The same lookups against an explicit dataset use the `clb_*()` form:

``` r

clb_tree(dataset = "COL25")
clb_classification("4CGXP", dataset = "COL25")
```

## Configuration

The base URL defaults to the production API and can be redirected with
the `CLB_BASE_URL` environment variable, e.g. to the development server:

``` r

Sys.setenv(CLB_BASE_URL = "https://api.dev.checklistbank.org")
```

## License

MIT © Catalogue of Life
