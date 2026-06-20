# Datasets -------------------------------------------------------------------

#' Search datasets in ChecklistBank
#'
#' Full-text and faceted search across all public datasets in ChecklistBank.
#' Uses the light dataset representation (`full = FALSE`) for speed.
#'
#' @param q Free-text query (matches title, alias, description, ...). Optional.
#' @param type Filter by dataset type (e.g. `"taxonomic"`, `"nomenclatural"`).
#' @param origin Filter by origin (e.g. `"external"`, `"project"`, `"release"`,
#'   `"xrelease"`).
#' @param ... Further query parameters forwarded to the `/dataset` endpoint
#'   (e.g. `contributesTo`, `code`, `gbifKey`).
#' @param limit Page size per request.
#' @param max Maximum number of datasets to return. Use `Inf` to fetch all.
#'
#' @return A [tibble][tibble::tibble] of datasets, one row each, with columns
#'   such as `key`, `alias`, `title`, `type`, `origin`, `license` and `issued`.
#' @seealso [clb_dataset()], [clb_dataset_metrics()]
#' @export
#' @examples
#' \dontrun{
#' clb_dataset_search("mammal")
#' clb_dataset_search(origin = "release", max = 1000)
#' }
clb_dataset_search <- function(q = NULL, type = NULL, origin = NULL, ...,
                               limit = 50L, max = limit) {
  paged <- clb_get_paged(
    "dataset",
    query = clb_query(q = q, type = type, origin = origin, full = FALSE, ...),
    limit = limit, max = max
  )
  new_clb(
    data = clb_records_to_tibble(paged$result),
    meta = list(total = paged$total)
  )
}

#' Get dataset metadata
#'
#' Retrieves the full metadata record for a single dataset.
#'
#' @param key Dataset key or alias (e.g. `3`, `"3LXR"`, `"COL25"`).
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A one-row [tibble][tibble::tibble] of dataset metadata (nested fields
#'   such as `contact` or `creator` are list-columns), or the raw list when
#'   `.raw = TRUE`.
#' @seealso [clb_dataset_search()], [clb_dataset_metrics()]
#' @export
#' @examples
#' \dontrun{
#' clb_dataset("3LXR")
#' clb_dataset(3)
#' }
clb_dataset <- function(key, .raw = FALSE) {
  resp <- clb_get("dataset", as.character(key))
  if (isTRUE(.raw)) return(resp)
  clb_records_to_tibble(list(resp))
}

#' Dataset metrics
#'
#' Returns the record counts of a dataset's most recent successful import
#' (or, for releases, the release build): numbers of names, taxa, synonyms,
#' vernacular names, distributions, references and so on, including by-rank and
#' by-gazetteer breakdowns.
#'
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A one-row [tibble][tibble::tibble] of metrics. Breakdown maps such as
#'   `usagesByRankCount` are returned as list-columns. `NULL` (with a message)
#'   if the dataset has no import yet.
#' @seealso [clb_dataset()], [clb_usage_metrics()]
#' @export
#' @examples
#' \dontrun{
#' clb_dataset_metrics()         # latest extended COL release
#' clb_dataset_metrics("COL25")
#' }
clb_dataset_metrics <- function(dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get(
    "dataset", as.character(dataset), "import",
    query = clb_query(limit = 1L)
  )
  if (isTRUE(.raw)) return(resp)
  if (!length(resp)) {
    cli::cli_inform("No import found for dataset {.val {dataset}}.")
    return(NULL)
  }
  clb_records_to_tibble(resp[1])
}
