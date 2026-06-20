# List the available ChecklistBank parsers

ChecklistBank exposes a family of parsers that interpret free text into
controlled values (ranks, countries, dates, licenses, nomenclatural
codes, taxonomic status, and more). This returns the names of all value
parsers usable with
[`clb_parse()`](https://catalogueoflife.github.io/rcol/reference/clb_parse.md).
The scientific-name parser is wrapped separately by
[`clb_parse_name()`](https://catalogueoflife.github.io/rcol/reference/clb_parse_name.md).

## Usage

``` r
clb_parsers()
```

## Value

A character vector of parser type names.

## See also

[`clb_parse()`](https://catalogueoflife.github.io/rcol/reference/clb_parse.md),
[`clb_parse_name()`](https://catalogueoflife.github.io/rcol/reference/clb_parse_name.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clb_parsers()
} # }
```
