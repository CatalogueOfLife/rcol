# Catalogue of Life shortcuts

Convenience siblings of the dataset-scoped `clb_*()` functions that
always operate on the latest extended Catalogue of Life release. They
take the same arguments as their `clb_*()` counterparts but without the
`dataset` parameter; the release is resolved once to its integer key via
[`col_key()`](https://catalogueoflife.github.io/rcol/reference/col_key.md)
and reused for the rest of the session (see
[`col_refresh()`](https://catalogueoflife.github.io/rcol/reference/col_refresh.md)
to re-pin).

## Usage

``` r
col_match(name, authorship = NULL, rank = NULL, code = NULL,
  server = NULL, .raw = FALSE)

col_match_verbose(name, authorship = NULL, rank = NULL, code = NULL,
  server = NULL, .raw = FALSE)

col_match_checklist(data, name = "name", authorship = "authorship",
  rank = "rank", code = "code", server = NULL, max_active = 5L)

col_dataset(.raw = FALSE)

col_dataset_metrics(.raw = FALSE)

col_usage(id, .raw = FALSE)

col_usage_search(q = NULL, rank = NULL, status = NULL, ..., limit = 50L,
  max = limit)

col_search(q = NULL, rank = NULL, status = NULL, ..., limit = 50L,
  max = limit)

col_suggest(q, ..., .raw = FALSE)

col_classification(id, .raw = FALSE)

col_synonyms(id, .raw = FALSE)

col_vernacular(id = NULL, q = NULL, lang = NULL, ..., limit = 50L,
  max = limit, .raw = FALSE)

col_usage_metrics(id, .raw = FALSE)

col_tree(id = NULL, extinct = TRUE, ..., limit = 100L, max = limit,
  .raw = FALSE)

col_children(id, extinct = TRUE, ..., limit = 100L, max = limit,
  .raw = FALSE)
```

## Arguments

- name, authorship, rank, code, server, data, max_active:

  See
  [`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md)
  and
  [`clb_match_checklist()`](https://catalogueoflife.github.io/rcol/reference/clb_match_checklist.md).

- .raw:

  Return the raw parsed JSON instead of a tibble?

- id:

  Usage or taxon id within the COL release.

- q:

  Free-text query (or partial name for `col_suggest()`).

- status:

  Taxonomic status filter.

- ...:

  Further query parameters forwarded to the underlying `clb_*()`
  function.

- limit, max:

  Pagination controls, as in the `clb_*()` functions.

- lang:

  ISO language filter for `col_vernacular()`.

- extinct:

  Logical; include extinct taxa in tree navigation.

## Value

As the corresponding `clb_*()` function.

## See also

[`col_key()`](https://catalogueoflife.github.io/rcol/reference/col_key.md),
[`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md),
[`clb_usage_search()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_search.md),
[`clb_tree()`](https://catalogueoflife.github.io/rcol/reference/clb_tree.md)

## Examples

``` r
if (FALSE) { # \dontrun{
col_match("Panthera leo")
col_usage_search("Felidae")
roots <- col_tree()
col_children(roots$id[1])
col_classification("4CGXP")
} # }
```
