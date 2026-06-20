# Parse values with a ChecklistBank value parser

Runs one of the controlled-value parsers (see
[`clb_parsers()`](https://catalogueoflife.github.io/rcol/reference/clb_parsers.md))
over a vector of strings, e.g. to normalise rank abbreviations, country
names, dates or license strings.

## Usage

``` r
clb_parse(type, q, .raw = FALSE)
```

## Arguments

- type:

  Parser type, one of
  [`clb_parsers()`](https://catalogueoflife.github.io/rcol/reference/clb_parsers.md)
  (e.g. `"rank"`, `"country"`, `"date"`, `"language"`, `"license"`,
  `"nomcode"`, `"taxonomicstatus"`).

- q:

  A character vector of values to parse.

- .raw:

  Return the raw parsed JSON instead of a tibble?

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
columns `original`, `parsed` and `parsable`, one row per input value.

## See also

[`clb_parsers()`](https://catalogueoflife.github.io/rcol/reference/clb_parsers.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_parse("rank", c("spec", "fam.", "ssp"))
clb_parse("country", c("Deutschland", "The Netherlands"))
} # }
```
