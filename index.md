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

# Match a name against the latest extended COL release (the default dataset)
clb_match("Panthera leo")

# Match many names at once
clb_match_checklist(c("Panthera leo", "Bufo bufo", "Abies alba"))

# Parse a scientific name into its components
clb_parse_name("Abies alba Mill.")
```

## Catalogue of Life releases

The Catalogue of Life is published in two cadences (monthly and annual)
and two flavours (a base release and an extended release `XR`). Every
function takes a `dataset =` argument; helpful aliases resolve to the
latest of each:

``` r

clb_col_release("monthly")                  # "3LR"   latest monthly base
clb_col_release("monthly", extended = TRUE) # "3LXR"  latest monthly extended (default)
clb_col_release("annual")                   # e.g. "COL25"

clb_usage_search("Felidae", dataset = "COL25")
```

## Datasets, taxa & tree

``` r

# Search datasets
clb_dataset_search("reptile")

# Walk the tree
roots <- clb_tree(dataset = "3LR")
clb_children(roots$id[1], dataset = "3LR")

# Classification and synonyms of a taxon
clb_classification("4CGXP", dataset = "3LR")
clb_synonyms("6DBT", dataset = "3LR")

# Metrics
clb_dataset_metrics()
clb_usage_metrics("4CGXP", dataset = "3LR")
```

## Configuration

The base URL defaults to the production API and can be redirected with
the `CLB_BASE_URL` environment variable, e.g. to the development server
or to a locally running [dockerized matching
container](https://www.catalogueoflife.org/tools/matching):

``` r

Sys.setenv(CLB_BASE_URL = "https://api.dev.checklistbank.org")
```

### Offline name matching

For high-volume or offline matching, the Catalogue of Life publishes
[dockerized matching
containers](https://www.catalogueoflife.org/tools/matching) that bundle
a release and expose a matching service locally:

``` sh
docker run -p 8080:8080 docker.gbif.org/matching-ws:xcol-amd64-latest
```

``` r

clb_match("Panthera leo", server = "http://localhost:8080")
```

## License

MIT © Catalogue of Life
