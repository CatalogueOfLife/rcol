# Name usages, taxa and related information ----------------------------------

# Hoist the most useful name fields out of the nested `name` object so a usage
# becomes a tidy single row; keep the full name object as a list-column.
clb_flatten_usage <- function(u) {
  nm <- u$name %||% list()
  list(
    id = u$id %||% NA_character_,
    scientific_name = nm$scientificName %||% u$name$scientificName %||% NA_character_,
    authorship = nm$authorship %||% NA_character_,
    rank = nm$rank %||% NA_character_,
    status = u$status %||% NA_character_,
    label = u$label %||% NA_character_,
    parent_id = u$parentId %||% NA_character_,
    extinct = u$extinct %||% NA,
    name = list(nm)
  )
}

# Recursively collect usage-like objects from (possibly nested) JSON nodes.
clb_as_usage_list <- function(x) {
  if (is.null(x)) return(list())
  if (!is.null(names(x)) && any(c("name", "id") %in% names(x))) return(list(x))
  if (is.list(x)) return(unlist(lapply(x, clb_as_usage_list), recursive = FALSE))
  list()
}

#' Get a name usage (taxon or synonym) by id
#'
#' @param id Usage id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A one-row [tibble][tibble::tibble] with the usage's `id`,
#'   `scientific_name`, `authorship`, `rank`, `status`, `label`, `parent_id`
#'   and the full nested `name` as a list-column.
#' @seealso [clb_usage_search()], [clb_classification()], [clb_synonyms()]
#' @export
#' @examples
#' \dontrun{
#' clb_usage("4CGXP", dataset = "3LR")
#' }
clb_usage <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "nameusage", as.character(id))
  if (isTRUE(.raw)) return(resp)
  tibble::as_tibble(clb_flatten_usage(resp))
}

#' Full-text search of name usages
#'
#' Searches name usages within a dataset (defaults to the latest extended COL
#' release). The accepted/synonym usage fields are hoisted to top-level columns;
#' the taxonomic classification and full name object are kept as list-columns.
#'
#' @param q Free-text query. Optional (omit to browse with filters only).
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param rank Filter by rank (e.g. `"species"`).
#' @param status Filter by taxonomic status (e.g. `"accepted"`, `"synonym"`).
#' @param ... Further query parameters forwarded to the search endpoint
#'   (e.g. `extinct`, `nomCode`, `minRank`, `maxRank`, `type`).
#' @param limit Page size per request.
#' @param max Maximum number of usages to return. Use `Inf` to fetch all.
#'
#' @return A `clb` object: a list with `$data` (a [tibble][tibble::tibble] of
#'   usages) and `$meta` (with `total`).
#' @seealso [clb_match()], [clb_suggest()], [clb_usage()]
#' @export
#' @examples
#' \dontrun{
#' clb_usage_search("Felidae")
#' clb_usage_search("Panthera", rank = "species", status = "accepted")
#' }
clb_usage_search <- function(q = NULL, dataset = "3LXR", rank = NULL,
                             status = NULL, ..., limit = 50L, max = limit) {
  paged <- clb_get_paged(
    "dataset", as.character(dataset), "nameusage", "search",
    query = clb_query(q = q, rank = rank, status = status, ...),
    limit = limit, max = max
  )
  rows <- lapply(paged$result, function(w) {
    row <- clb_flatten_usage(w$usage %||% list())
    row$group <- w$group %||% NA_character_
    row$classification <- list(w$classification %||% list())
    row
  })
  new_clb(data = clb_bind_rows(rows), meta = list(total = paged$total))
}

#' @rdname clb_usage_search
#' @export
clb_search <- clb_usage_search

#' Autocomplete suggestions for name usages
#'
#' Fast prefix-based suggestions, suitable for type-ahead lookups.
#'
#' @param q Partial name to complete.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param ... Further query parameters (e.g. `rank`, `status`).
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of suggestions with columns such as
#'   `suggestion`, `usageId`, `rank`, `status` and `group`.
#' @seealso [clb_usage_search()]
#' @export
#' @examples
#' \dontrun{
#' clb_suggest("Panth")
#' }
clb_suggest <- function(q, dataset = "3LXR", ..., .raw = FALSE) {
  resp <- clb_get(
    "dataset", as.character(dataset), "nameusage", "suggest",
    query = clb_query(q = q, ...)
  )
  if (isTRUE(.raw)) return(resp)
  clb_records_to_tibble(resp)
}

#' Taxonomic classification (lineage) of a taxon
#'
#' Returns the ordered parent chain from the root down to the taxon.
#'
#' @param id Taxon id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of ancestors, one row per rank, with
#'   columns `id`, `name`, `authorship`, `rank` and `labelHtml`.
#' @seealso [clb_usage()], [clb_children()]
#' @export
#' @examples
#' \dontrun{
#' clb_classification("4CGXP", dataset = "3LR")
#' }
clb_classification <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), "classification")
  if (isTRUE(.raw)) return(resp)
  clb_records_to_tibble(resp)
}

#' Synonyms of a taxon
#'
#' @param id Taxon id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of synonym usages with a `synonym_type`
#'   column (`"homotypic"` or `"heterotypic"`) and the usual flattened usage
#'   columns. Zero rows when the taxon has no synonyms.
#' @seealso [clb_usage()]
#' @export
#' @examples
#' \dontrun{
#' clb_synonyms("6DBT", dataset = "3LR")
#' }
clb_synonyms <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), "synonyms")
  if (isTRUE(.raw)) return(resp)

  homo <- clb_as_usage_list(resp$homotypic)
  het <- clb_as_usage_list(c(resp$heterotypic, resp$heterotypicGroups))
  tag <- function(lst, type) lapply(lst, function(s) {
    r <- clb_flatten_usage(s)
    r$synonym_type <- type
    r
  })
  rows <- c(tag(homo, "homotypic"), tag(het, "heterotypic"))
  if (!length(rows)) return(tibble::tibble())
  out <- clb_bind_rows(rows)
  out[c("synonym_type", setdiff(names(out), "synonym_type"))]
}

#' Vernacular (common) names
#'
#' Looks up vernacular names either for a single taxon (when `id` is given) or
#' across a dataset by free-text query.
#'
#' @param id Optional taxon id. When supplied, returns the vernacular names of
#'   that taxon; otherwise performs a dataset-wide vernacular search using `q`.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param q Free-text query for the dataset-wide search (ignored when `id` is
#'   supplied).
#' @param lang Optional ISO language filter (e.g. `"eng"`, `"deu"`).
#' @param ... Further query parameters.
#' @param limit Page size for the dataset-wide search.
#' @param max Maximum rows for the dataset-wide search.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of vernacular names with columns such as
#'   `name`, `latin`, `language` and `taxonID`.
#' @export
#' @examples
#' \dontrun{
#' clb_vernacular(id = "4CGXP", dataset = "3LR")
#' clb_vernacular(q = "lion", lang = "eng")
#' }
clb_vernacular <- function(id = NULL, dataset = "3LXR", q = NULL, lang = NULL,
                           ..., limit = 50L, max = limit, .raw = FALSE) {
  if (!is.null(id)) {
    resp <- clb_get(
      "dataset", as.character(dataset), "taxon", as.character(id), "vernacular",
      query = clb_query(lang = lang)
    )
    if (isTRUE(.raw)) return(resp)
    return(clb_records_to_tibble(resp))
  }
  paged <- clb_get_paged(
    "dataset", as.character(dataset), "vernacular",
    query = clb_query(q = q, lang = lang, ...),
    limit = limit, max = max
  )
  clb_records_to_tibble(paged$result)
}

#' Metrics for a taxon
#'
#' Returns subtree metrics for a taxon: tree depth, child and species counts,
#' and a by-rank breakdown of descendants.
#'
#' @param id Taxon id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A one-row [tibble][tibble::tibble] of metrics. Map fields such as
#'   `taxaByRankCount` are returned as list-columns.
#' @seealso [clb_dataset_metrics()], [clb_children()]
#' @export
#' @examples
#' \dontrun{
#' clb_usage_metrics("4CGXP", dataset = "3LR")
#' }
clb_usage_metrics <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), "metrics")
  if (isTRUE(.raw)) return(resp)
  clb_records_to_tibble(list(resp))
}
