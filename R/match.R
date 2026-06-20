# Name matching --------------------------------------------------------------

clb_match_req <- function(name = NULL, authorship = NULL, rank = NULL,
                          code = NULL, dataset = "3LXR", verbose = FALSE,
                          base_url = clb_base_url()) {
  req <- clb_request(base_url = base_url)
  req <- httr2::req_url_path_append(
    req, "dataset", as.character(dataset), "match", "nameusage"
  )
  q <- clb_query(
    q = name, authorship = authorship, rank = rank,
    code = code, verbose = verbose
  )
  if (length(q)) req <- httr2::req_url_query(req, !!!q)
  req
}

# Flatten a usage object (the matched usage or an alternative) into a row list.
clb_usage_row <- function(usage) {
  list(
    usage_id = usage$id %||% NA_character_,
    name = usage$name %||% NA_character_,
    authorship = usage$authorship %||% NA_character_,
    rank = usage$rank %||% NA_character_,
    status = usage$status %||% NA_character_,
    code = usage$code %||% NA_character_,
    label = usage$label %||% NA_character_,
    names_index_id = usage$namesIndexId %||% NA_character_,
    names_index_match_type = usage$namesIndexMatchType %||% NA_character_,
    classification = list(usage$classification %||% list())
  )
}

# Build a one-row data list from a full match response.
clb_match_row <- function(resp) {
  usage <- resp$usage
  matched <- resp$match %||% !is.null(usage)
  row <- c(
    list(
      match = isTRUE(matched),
      match_type = resp$type %||% NA_character_
    ),
    clb_usage_row(usage %||% list())
  )
  row
}

#' Match a scientific name against a ChecklistBank dataset
#'
#' Looks up the single best-matching name usage for a scientific name in a
#' dataset, defaulting to the latest monthly extended Catalogue of Life release
#' (`"3LXR"`). This is the Catalogue of Life analogue of GBIF's name backbone
#' matching.
#'
#' @param name Scientific name to match. May include the authorship, or supply
#'   it separately via `authorship`.
#' @param authorship Optional authorship string.
#' @param rank Optional rank to disambiguate (e.g. `"species"`, `"genus"`).
#' @param code Optional nomenclatural code (`"zoological"`, `"botanical"`,
#'   `"bacterial"`, `"virus"`, ...).
#' @param dataset Dataset key or alias to match against. Defaults to `"3LXR"`.
#'   See [clb_col_release()] for the COL release aliases.
#' @param server Optional base URL of an alternative matching service, e.g. a
#'   locally running dockerized matching container
#'   (`"http://localhost:8080"`). Overrides `CLB_BASE_URL` for this call.
#' @param .raw Return the raw parsed JSON response instead of a tibble?
#'
#' @return A one-row [tibble][tibble::tibble] with the match outcome
#'   (`match`, `match_type`), the matched usage (`usage_id`, `name`,
#'   `authorship`, `rank`, `status`, ...) and a `classification` list-column.
#'   When nothing matches, `match` is `FALSE` and the usage columns are `NA`.
#' @seealso [clb_match_verbose()], [clb_match_checklist()]
#' @export
#' @examples
#' \dontrun{
#' clb_match("Panthera leo")
#' clb_match("Abies alba", rank = "species", code = "botanical")
#' clb_match("Felis catus", dataset = "COL25")
#' }
clb_match <- function(name, authorship = NULL, rank = NULL, code = NULL,
                      dataset = "3LXR", server = NULL, .raw = FALSE) {
  base_url <- server %||% clb_base_url()
  req <- clb_match_req(
    name = name, authorship = authorship, rank = rank, code = code,
    dataset = dataset, verbose = FALSE, base_url = base_url
  )
  resp <- httr2::resp_body_json(httr2::req_perform(req), simplifyVector = FALSE)
  if (isTRUE(.raw)) return(resp)
  tibble::as_tibble(clb_match_row(resp))
}

#' Match a name and return all candidate usages
#'
#' Like [clb_match()] but requests verbose output and returns the matched usage
#' together with all alternative candidates, one per row.
#'
#' @inheritParams clb_match
#'
#' @return A [tibble][tibble::tibble] of candidate usages with a logical
#'   `primary` column flagging the chosen match. Zero rows when nothing matched.
#' @seealso [clb_match()]
#' @export
#' @examples
#' \dontrun{
#' clb_match_verbose("Oenanthe")
#' }
clb_match_verbose <- function(name, authorship = NULL, rank = NULL, code = NULL,
                              dataset = "3LXR", server = NULL, .raw = FALSE) {
  base_url <- server %||% clb_base_url()
  req <- clb_match_req(
    name = name, authorship = authorship, rank = rank, code = code,
    dataset = dataset, verbose = TRUE, base_url = base_url
  )
  resp <- httr2::resp_body_json(httr2::req_perform(req), simplifyVector = FALSE)
  if (isTRUE(.raw)) return(resp)

  usages <- list()
  primary <- logical()
  if (!is.null(resp$usage)) {
    usages <- c(usages, list(resp$usage))
    primary <- c(primary, TRUE)
  }
  alts <- resp$alternatives %||% list()
  if (length(alts)) {
    usages <- c(usages, alts)
    primary <- c(primary, rep(FALSE, length(alts)))
  }
  if (!length(usages)) return(tibble::tibble())
  rows <- Map(function(u, p) {
    r <- clb_usage_row(u)
    r$primary <- p
    r
  }, usages, primary)
  out <- clb_bind_rows(rows)
  out[c("primary", setdiff(names(out), "primary"))]
}

#' Match a checklist of names in bulk
#'
#' Matches many names at once, issuing requests in parallel. Input columns are
#' echoed back on each row with a `verbatim_` prefix so results stay aligned
#' with the source.
#'
#' @param data A character vector of names, or a data frame. For a data frame,
#'   the columns named by `name`, `authorship`, `rank` and `code` are used
#'   (missing ones are ignored).
#' @param name,authorship,rank,code Column names in `data` (when `data` is a
#'   data frame) holding the respective fields.
#' @param dataset Dataset key or alias to match against. Defaults to `"3LXR"`.
#' @param server Optional alternative matching service base URL (see
#'   [clb_match()]).
#' @param max_active Maximum number of simultaneous HTTP requests.
#'
#' @return A [tibble][tibble::tibble] with one row per input, the `verbatim_*`
#'   input columns first followed by the match result columns of [clb_match()].
#' @seealso [clb_match()]
#' @export
#' @examples
#' \dontrun{
#' clb_match_checklist(c("Panthera leo", "Bufo bufo", "Abies alba"))
#'
#' df <- data.frame(
#'   sciname = c("Puma concolor", "Vulpes vulpes"),
#'   rank = c("species", "species")
#' )
#' clb_match_checklist(df, name = "sciname", rank = "rank")
#' }
clb_match_checklist <- function(data, name = "name", authorship = "authorship",
                                rank = "rank", code = "code", dataset = "3LXR",
                                server = NULL, max_active = 5L) {
  base_url <- server %||% clb_base_url()

  if (is.character(data) || is.factor(data)) {
    data <- tibble::tibble(name = as.character(data))
    name <- "name"
  }
  data <- tibble::as_tibble(data)

  pick <- function(col) if (!is.null(col) && col %in% names(data)) as.character(data[[col]]) else NULL
  names_v <- pick(name)
  if (is.null(names_v)) {
    cli::cli_abort("Column {.val {name}} not found in {.arg data}.")
  }
  auth_v <- pick(authorship)
  rank_v <- pick(rank)
  code_v <- pick(code)

  n <- nrow(data)
  reqs <- lapply(seq_len(n), function(i) {
    clb_match_req(
      name = names_v[[i]],
      authorship = if (!is.null(auth_v)) auth_v[[i]],
      rank = if (!is.null(rank_v)) rank_v[[i]],
      code = if (!is.null(code_v)) code_v[[i]],
      dataset = dataset, verbose = FALSE, base_url = base_url
    )
  })

  resps <- httr2::req_perform_parallel(reqs, max_active = max_active, on_error = "continue")
  rows <- lapply(resps, function(resp) {
    if (inherits(resp, "error") || inherits(resp, "condition")) {
      return(clb_match_row(list()))
    }
    clb_match_row(httr2::resp_body_json(resp, simplifyVector = FALSE))
  })
  result <- clb_bind_rows(rows)

  verbatim <- data
  names(verbatim) <- paste0("verbatim_", names(verbatim))
  tibble::as_tibble(c(as.list(verbatim), as.list(result)))
}
