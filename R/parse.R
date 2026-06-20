# Parsers --------------------------------------------------------------------

#' List the available ChecklistBank parsers
#'
#' ChecklistBank exposes a family of parsers that interpret free text into
#' controlled values (ranks, countries, dates, licenses, nomenclatural codes,
#' taxonomic status, and more). This returns the names of all value parsers
#' usable with [clb_parse()]. The scientific-name parser is wrapped separately
#' by [clb_parse_name()].
#'
#' @return A character vector of parser type names.
#' @seealso [clb_parse()], [clb_parse_name()]
#' @export
#' @examples
#' \dontrun{
#' clb_parsers()
#' }
clb_parsers <- function() {
  res <- clb_get("parser")
  unlist(res, use.names = FALSE)
}

#' Parse scientific names
#'
#' Atomises one or more scientific names into their nomenclatural components
#' (genus, epithets, rank, authorship, ...) using the GBIF name parser exposed
#' by ChecklistBank.
#'
#' @param name A character vector of scientific names (may include authorship).
#' @param authorship Optional authorship string (used when a single `name` is
#'   supplied without its author).
#' @param rank Optional rank hint (e.g. `"species"`).
#' @param code Optional nomenclatural code hint.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] with one row per input name and columns
#'   such as `scientificName`, `authorship`, `rank`, `genus`,
#'   `specificEpithet`, `type` and `parsed`. Nested fields (e.g.
#'   `combinationAuthorship`) are returned as list-columns.
#' @seealso [clb_parse()], [clb_match()]
#' @export
#' @examples
#' \dontrun{
#' clb_parse_name("Abies alba Mill.")
#' clb_parse_name(c("Panthera leo (Linnaeus, 1758)", "Bellis perennis L."))
#' }
clb_parse_name <- function(name, authorship = NULL, rank = NULL, code = NULL,
                           .raw = FALSE) {
  resp <- clb_get(
    "parser", "name",
    query = clb_query(q = name, authorship = authorship, rank = rank, code = code)
  )
  if (isTRUE(.raw)) return(resp)
  records <- if (!is.null(names(resp))) list(resp) else resp
  clb_records_to_tibble(records)
}

#' Parse values with a ChecklistBank value parser
#'
#' Runs one of the controlled-value parsers (see [clb_parsers()]) over a vector
#' of strings, e.g. to normalise rank abbreviations, country names, dates or
#' license strings.
#'
#' @param type Parser type, one of [clb_parsers()] (e.g. `"rank"`,
#'   `"country"`, `"date"`, `"language"`, `"license"`, `"nomcode"`,
#'   `"taxonomicstatus"`).
#' @param q A character vector of values to parse.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] with columns `original`, `parsed` and
#'   `parsable`, one row per input value.
#' @seealso [clb_parsers()]
#' @export
#' @examples
#' \dontrun{
#' clb_parse("rank", c("spec", "fam.", "ssp"))
#' clb_parse("country", c("Deutschland", "The Netherlands"))
#' }
clb_parse <- function(type, q, .raw = FALSE) {
  resp <- clb_get("parser", type, query = clb_query(q = q))
  if (isTRUE(.raw)) return(resp)
  records <- if (!is.null(names(resp))) list(resp) else resp
  clb_records_to_tibble(records)
}
