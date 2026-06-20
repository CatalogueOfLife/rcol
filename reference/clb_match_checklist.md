# Match a checklist of names in bulk

Matches many names at once, issuing requests in parallel. Input columns
are echoed back on each row with a `verbatim_` prefix so results stay
aligned with the source.

## Usage

``` r
clb_match_checklist(
  data,
  name = "name",
  authorship = "authorship",
  rank = "rank",
  code = "code",
  dataset = "3LXR",
  server = NULL,
  max_active = 5L
)
```

## Arguments

- data:

  A character vector of names, or a data frame. For a data frame, the
  columns named by `name`, `authorship`, `rank` and `code` are used
  (missing ones are ignored).

- name, authorship, rank, code:

  Column names in `data` (when `data` is a data frame) holding the
  respective fields.

- dataset:

  Dataset key or alias to match against. Defaults to `"3LXR"`.

- server:

  Optional alternative matching service base URL (see
  [`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md)).

- max_active:

  Maximum number of simultaneous HTTP requests.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with one
row per input, the `verbatim_*` input columns first followed by the
match result columns of
[`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md).

## See also

[`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_match_checklist(c("Panthera leo", "Bufo bufo", "Abies alba"))

df <- data.frame(
  sciname = c("Puma concolor", "Vulpes vulpes"),
  rank = c("species", "species")
)
clb_match_checklist(df, name = "sciname", rank = "rank")
} # }
```
