# Catalogue of Life release discovery ----------------------------------------

# Session state: the resolved integer key of the pinned COL release.
.rcol_state <- new.env(parent = emptyenv())

#' The pinned Catalogue of Life release key
#'
#' Resolves the latest monthly extended Catalogue of Life release (the `"3LXR"`
#' alias) to its concrete integer dataset key and caches it for the rest of the
#' session. All `col_*()` convenience functions use this key, so a new release
#' published mid-session will not silently change the data you are working
#' against during a long-running job. Call [col_refresh()] to re-resolve.
#'
#' @param refresh Logical. Force re-resolution of the latest release even if a
#'   key is already cached.
#'
#' @return The integer dataset key of the pinned COL extended release.
#' @seealso [col_refresh()], [clb_col_release()]
#' @export
#' @examples
#' \dontrun{
#' col_key()
#' }
col_key <- function(refresh = FALSE) {
  if (isTRUE(refresh) || is.null(.rcol_state$col_key)) {
    d <- clb_get("dataset", "3LXR")
    key <- d$key
    if (is.null(key)) {
      cli::cli_abort("Could not resolve the latest COL extended release ({.val 3LXR}).")
    }
    .rcol_state$col_key <- as.integer(key)
    .rcol_state$col_alias <- d$alias %||% NA_character_
  }
  .rcol_state$col_key
}

#' Re-pin the Catalogue of Life release
#'
#' Re-resolves the latest extended COL release and updates the key cached by
#' [col_key()]. Use this to pick up a newly published release within a running
#' session.
#'
#' @return The integer dataset key of the newly pinned release, invisibly.
#' @seealso [col_key()]
#' @export
#' @examples
#' \dontrun{
#' col_refresh()
#' }
col_refresh <- function() {
  col_key(refresh = TRUE)
  cli::cli_inform(
    "Pinned COL to {.val {.rcol_state$col_alias}} (dataset {.val {.rcol_state$col_key}})."
  )
  invisible(.rcol_state$col_key)
}

# Internal: drop the cached key (used by tests).
col_cache_clear <- function() {
  .rcol_state$col_key <- NULL
  .rcol_state$col_alias <- NULL
  invisible(NULL)
}

#' Resolve a Catalogue of Life release
#'
#' The Catalogue of Life is published as a managed project (dataset key `3`)
#' from which immutable *releases* are derived. There are two cadences
#' (monthly and annual) and two flavours (a *base* release and an *extended*
#' release `XR`, which merges additional external data). This helper returns
#' the dataset identifier (an alias such as `"3LXR"` or `"COL25"`) you can pass
#' to any `dataset =` argument in this package.
#'
#' The monthly releases have stable magic aliases that always point at the most
#' recent one:
#'
#' * `"3LR"` -- latest monthly **base** release
#' * `"3LXR"` -- latest monthly **extended** release
#'
#' Annual releases use a `COL<YY>` alias (e.g. `"COL25"`, and `"COL25 XR"` for
#' the extended variant). The latest one is discovered from the list of all
#' releases of project `3`.
#'
#' @param cadence Either `"monthly"` (the default) or `"annual"`.
#' @param extended Logical. Return the extended release (`XR`) instead of the
#'   base release? Defaults to `FALSE`.
#'
#' @return A length-one character vector with the release alias, or `NA` (with
#'   a warning) when the requested release has not been published yet -- as is
#'   currently the case for the annual extended release.
#' @seealso [clb_col_releases()] for the full list of releases.
#' @export
#' @examples
#' \dontrun{
#' clb_col_release("monthly")                  # "3LR"
#' clb_col_release("monthly", extended = TRUE) # "3LXR"
#' clb_col_release("annual")                   # e.g. "COL25"
#' }
clb_col_release <- function(cadence = c("monthly", "annual"), extended = FALSE) {
  cadence <- match.arg(cadence)
  if (cadence == "monthly") {
    return(if (isTRUE(extended)) "3LXR" else "3LR")
  }

  releases <- clb_col_releases()
  alias <- releases$alias
  alias <- alias[!is.na(alias)]
  pattern <- if (isTRUE(extended)) "^COL\\d+ ?XR$" else "^COL\\d+$"
  hits <- alias[grepl(pattern, alias)]
  if (!length(hits)) {
    cli::cli_warn(c(
      "No annual {if (isTRUE(extended)) 'extended ' else ''}COL release has been published yet.",
      "i" = "Returning {.val {NA_character_}}."
    ))
    return(NA_character_)
  }
  year <- as.integer(gsub("\\D", "", hits))
  hits[which.max(year)]
}

#' List all Catalogue of Life releases
#'
#' Returns every release (base and extended) derived from the Catalogue of Life
#' project (dataset key `3`), most useful for discovering historical annual
#' releases such as `COL23`, `COL24`, `COL25`.
#'
#' @param project Integer project key. Defaults to `3` (the Catalogue of Life).
#' @param ... Additional query parameters passed to the `/dataset` endpoint.
#'
#' @return A [tibble][tibble::tibble] of releases with columns such as `key`,
#'   `alias`, `title`, `origin`, `issued` and `version`.
#' @export
#' @examples
#' \dontrun{
#' clb_col_releases()
#' }
clb_col_releases <- function(project = 3L, ...) {
  paged <- clb_get_paged(
    "dataset",
    query = clb_query(releasedFrom = project, full = FALSE, ...),
    limit = 100L, max = Inf
  )
  clb_records_to_tibble(paged$result)
}
