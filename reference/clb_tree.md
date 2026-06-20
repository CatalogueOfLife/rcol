# Navigate the taxonomic tree

Without `id`, returns the root taxa of the dataset's tree. With `id`,
returns the path (lineage) from the root down to that taxon. Use
[`clb_children()`](https://catalogueoflife.github.io/rcol/reference/clb_children.md)
to descend one level.

## Usage

``` r
clb_tree(
  dataset = "3LXR",
  id = NULL,
  extinct = TRUE,
  ...,
  limit = 100L,
  max = limit,
  .raw = FALSE
)
```

## Arguments

- dataset:

  Dataset key or alias. Defaults to `"3LXR"`.

- id:

  Optional taxon id. When omitted the tree roots are returned.

- extinct:

  Logical; include extinct taxa. Defaults to `TRUE`.

- ...:

  Further query parameters (e.g. `insertPlaceholder`).

- limit:

  Page size when listing roots.

- max:

  Maximum number of roots to return.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of tree
nodes with columns such as `id`, `name`, `authorship`, `rank`, `status`,
`childCount` and `count`.

## See also

[`clb_children()`](https://catalogueoflife.github.io/rcol/reference/clb_children.md),
[`clb_classification()`](https://catalogueoflife.github.io/rcol/reference/clb_classification.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_tree(dataset = "3LR")            # kingdoms / roots
clb_tree(dataset = "3LR", id = "4CGXP")  # lineage of a taxon
} # }
```
