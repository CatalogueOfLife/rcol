# Catalogue of Life shortcuts ------------------------------------------------
#
# Thin siblings of the clb_*() functions that drop the `dataset` argument and
# always target the latest extended Catalogue of Life release, pinned to a
# concrete integer key via col_key() so the release cannot change mid-session.

#' Catalogue of Life shortcuts
#'
#' Convenience siblings of the dataset-scoped `clb_*()` functions that always
#' operate on the latest extended Catalogue of Life release. They take the same
#' arguments as their `clb_*()` counterparts but without the `dataset`
#' parameter; the release is resolved once to its integer key via [col_key()]
#' and reused for the rest of the session (see [col_refresh()] to re-pin).
#'
#' @param name,authorship,rank,code,server,data,max_active See [clb_match()] and
#'   [clb_match_checklist()].
#' @param id Usage or taxon id within the COL release.
#' @param q Free-text query (or partial name for [col_suggest()]).
#' @param status Taxonomic status filter.
#' @param lang ISO language filter for [col_vernacular()].
#' @param extinct Logical; include extinct taxa in tree navigation.
#' @param limit,max Pagination controls, as in the `clb_*()` functions.
#' @param ... Further query parameters forwarded to the underlying `clb_*()`
#'   function.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return As the corresponding `clb_*()` function.
#' @seealso [col_key()], [clb_match()], [clb_usage_search()], [clb_tree()]
#' @name col_shortcuts
#' @examples
#' \dontrun{
#' col_match("Panthera leo")
#' col_usage_search("Felidae")
#' roots <- col_tree()
#' col_children(roots$id[1])
#' col_classification("4CGXP")
#' }
NULL

#' @rdname col_shortcuts
#' @export
col_match <- function(name, authorship = NULL, rank = NULL, code = NULL,
                      server = NULL, .raw = FALSE) {
  clb_match(name, authorship, rank, code, dataset = col_key(),
            server = server, .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_match_verbose <- function(name, authorship = NULL, rank = NULL, code = NULL,
                              server = NULL, .raw = FALSE) {
  clb_match_verbose(name, authorship, rank, code, dataset = col_key(),
                    server = server, .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_match_checklist <- function(data, name = "name", authorship = "authorship",
                                rank = "rank", code = "code", server = NULL,
                                max_active = 5L) {
  clb_match_checklist(data, name = name, authorship = authorship, rank = rank,
                      code = code, dataset = col_key(), server = server,
                      max_active = max_active)
}

#' @rdname col_shortcuts
#' @export
col_dataset <- function(.raw = FALSE) {
  clb_dataset(col_key(), .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_dataset_metrics <- function(.raw = FALSE) {
  clb_dataset_metrics(col_key(), .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_usage <- function(id, .raw = FALSE) {
  clb_usage(id, dataset = col_key(), .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_usage_search <- function(q = NULL, rank = NULL, status = NULL, ...,
                             limit = 50L, max = limit) {
  clb_usage_search(q, dataset = col_key(), rank = rank, status = status, ...,
                   limit = limit, max = max)
}

#' @rdname col_shortcuts
#' @export
col_search <- col_usage_search

#' @rdname col_shortcuts
#' @export
col_suggest <- function(q, ..., .raw = FALSE) {
  clb_suggest(q, dataset = col_key(), ..., .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_classification <- function(id, .raw = FALSE) {
  clb_classification(id, dataset = col_key(), .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_synonyms <- function(id, .raw = FALSE) {
  clb_synonyms(id, dataset = col_key(), .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_vernacular <- function(id = NULL, q = NULL, lang = NULL, ...,
                           limit = 50L, max = limit, .raw = FALSE) {
  clb_vernacular(id = id, dataset = col_key(), q = q, lang = lang, ...,
                 limit = limit, max = max, .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_usage_metrics <- function(id, .raw = FALSE) {
  clb_usage_metrics(id, dataset = col_key(), .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_tree <- function(id = NULL, extinct = TRUE, ..., limit = 100L, max = limit,
                     .raw = FALSE) {
  clb_tree(dataset = col_key(), id = id, extinct = extinct, ...,
           limit = limit, max = max, .raw = .raw)
}

#' @rdname col_shortcuts
#' @export
col_children <- function(id, extinct = TRUE, ..., limit = 100L, max = limit,
                         .raw = FALSE) {
  clb_children(id, dataset = col_key(), extinct = extinct, ...,
               limit = limit, max = max, .raw = .raw)
}
