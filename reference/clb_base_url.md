# The ChecklistBank API base URL

Returns the base URL all requests are sent to. Defaults to the public
production API and can be overridden with the `CLB_BASE_URL` environment
variable, e.g. to target the development server
(`https://api.dev.checklistbank.org`) or a locally running dockerized
matching container (`http://localhost:8080`).

## Usage

``` r
clb_base_url()
```

## Value

A length-one character vector with the base URL.

## Examples

``` r
clb_base_url()
#> [1] "https://api.checklistbank.org"
```
