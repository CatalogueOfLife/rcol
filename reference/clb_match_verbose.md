# Match a name and return all candidate usages

Like
[`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md)
but requests verbose output and returns the matched usage together with
all alternative candidates, one per row.

## Usage

``` r
clb_match_verbose(
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

  Dataset key or alias to match against. Defaults to `"3LXR"`.

- server:

  Optional base URL of an alternative matching service.

- .raw:

  Return the raw parsed JSON response instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of
candidate usages with a logical `primary` column flagging the chosen
match. Zero rows when nothing matched.

## See also

[`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_match_verbose("Oenanthe")
} # }
```
