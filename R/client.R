# Internal HTTP client for the ChecklistBank API -----------------------------

#' The ChecklistBank API base URL
#'
#' Returns the base URL all requests are sent to. Defaults to the public
#' production API and can be overridden with the `CLB_BASE_URL` environment
#' variable, e.g. to target the development server
#' (`https://api.dev.checklistbank.org`) or a locally running dockerized
#' matching container (`http://localhost:8080`).
#'
#' @return A length-one character vector with the base URL.
#' @export
#' @examples
#' clb_base_url()
clb_base_url <- function() {
  Sys.getenv("CLB_BASE_URL", unset = "https://api.checklistbank.org")
}

clb_user_agent <- function() {
  v <- tryCatch(as.character(utils::packageVersion("rcol")), error = function(e) "dev")
  paste0("rcol/", v, " (https://github.com/CatalogueOfLife/rcol)")
}

clb_is_transient <- function(resp) {
  httr2::resp_status(resp) %in% c(429L, 500L, 502L, 503L, 504L)
}

clb_error_body <- function(resp) {
  ct <- tryCatch(httr2::resp_content_type(resp), error = function(e) "")
  if (length(ct) && grepl("json", ct, fixed = TRUE)) {
    body <- tryCatch(httr2::resp_body_json(resp), error = function(e) NULL)
    msg <- body$message %||% body$error %||% body$details
    if (!is.null(msg)) return(as.character(msg))
  }
  txt <- tryCatch(httr2::resp_body_string(resp), error = function(e) "")
  if (length(txt) && nzchar(txt)) substr(txt, 1L, 200L) else NULL
}

#' Build a base httr2 request for the ChecklistBank API
#'
#' Internal helper. Sets the user agent, transient-error retries, polite
#' throttling and error-body extraction, and adds HTTP basic auth when the
#' `CLB_USER` / `CLB_PWD` environment variables are set.
#'
#' @param base_url API base URL.
#' @return An [httr2::request()] object.
#' @keywords internal
#' @noRd
clb_request <- function(base_url = clb_base_url()) {
  req <- httr2::request(base_url)
  req <- httr2::req_user_agent(req, clb_user_agent())
  req <- httr2::req_retry(req, max_tries = 3L, is_transient = clb_is_transient)
  req <- httr2::req_throttle(req, capacity = 10, fill_time_s = 1)
  req <- httr2::req_error(req, body = clb_error_body)

  user <- Sys.getenv("CLB_USER")
  pwd <- Sys.getenv("CLB_PWD")
  if (nzchar(user) && nzchar(pwd)) {
    req <- httr2::req_auth_basic(req, user, pwd)
  }
  req
}

# Drop NULLs and lowercase logicals so the API receives true/false.
clb_query <- function(...) {
  q <- list(...)
  q <- q[!vapply(q, is.null, logical(1))]
  lapply(q, function(v) if (is.logical(v)) tolower(as.character(v)) else v)
}

#' Perform a GET request and return parsed JSON
#'
#' @param ... Path segments appended to the base URL (each is URL-encoded).
#' @param query A named list of query parameters.
#' @param base_url API base URL.
#' @return The parsed JSON body as a nested list.
#' @keywords internal
#' @noRd
clb_get <- function(..., query = list(), base_url = clb_base_url()) {
  segments <- as.character(unlist(list(...)))
  req <- clb_request(base_url = base_url)
  req <- do.call(httr2::req_url_path_append, c(list(req), as.list(segments)))
  if (length(query)) {
    req <- httr2::req_url_query(req, !!!query, .multi = "explode")
  }
  resp <- httr2::req_perform(req)
  httr2::resp_body_json(resp, simplifyVector = FALSE)
}

#' Fetch all (or up to `max`) records from a paged ChecklistBank endpoint
#'
#' Walks the `offset`/`limit` `ResultPage` pagination until the last page is
#' reached or `max` records have been collected.
#'
#' @param ... Path segments.
#' @param query Base query parameters (pagination is added automatically).
#' @param limit Page size (server max is 1000).
#' @param max Maximum number of records to return. Use `Inf` for everything.
#' @param base_url API base URL.
#' @return A list with elements `result` (list of records) and `total`.
#' @keywords internal
#' @noRd
clb_get_paged <- function(..., query = list(), limit = 50L, max = limit,
                          base_url = clb_base_url()) {
  page_size <- min(limit, max, 1000L)
  offset <- 0L
  collected <- list()
  total <- NA_integer_
  repeat {
    q <- c(query, clb_query(limit = page_size, offset = offset))
    page <- clb_get(..., query = q, base_url = base_url)
    res <- page$result %||% list()
    total <- page$total %||% total
    collected <- c(collected, res)
    if (isTRUE(page$last) || length(res) == 0L || length(collected) >= max) break
    offset <- offset + page_size
  }
  if (length(collected) > max) collected <- collected[seq_len(max)]
  list(result = collected, total = total)
}

# Tibble conversion ----------------------------------------------------------

# Coerce a list of length-1 atomic values (with NULLs) into an atomic vector,
# preserving type and turning NULL/empty into NA.
clb_coerce_scalar <- function(vals) {
  vals <- lapply(vals, function(v) if (length(v) == 0L) NA else v[[1]])
  unlist(vals, use.names = FALSE)
}

# Turn a list of (named) record lists into a tibble. Scalar fields become
# atomic columns; nested or multi-valued fields become list-columns.
clb_records_to_tibble <- function(records) {
  if (!length(records)) return(tibble::tibble())
  keys <- unique(unlist(lapply(records, names)))
  cols <- lapply(keys, function(k) {
    vals <- lapply(records, function(r) r[[k]])
    is_scalar <- vapply(
      vals,
      function(v) is.null(v) || (length(v) == 1L && is.atomic(v)),
      logical(1)
    )
    if (all(is_scalar)) clb_coerce_scalar(vals) else vals
  })
  names(cols) <- keys
  tibble::as_tibble(cols)
}

# Row-bind a list of named "row" lists into a tibble. Each row value is either
# a scalar atomic (atomic column) or a length-1 list wrapping a cell value
# (list-column). Avoids rbind() on tibbles, which mangles list-columns.
clb_bind_rows <- function(rows) {
  if (!length(rows)) return(tibble::tibble())
  keys <- unique(unlist(lapply(rows, names)))
  cols <- lapply(keys, function(k) {
    vals <- lapply(rows, function(r) r[[k]])
    is_listcol <- any(vapply(vals, is.list, logical(1)))
    if (is_listcol) {
      lapply(vals, function(v) if (is.null(v)) NULL else v[[1]])
    } else {
      clb_coerce_scalar(vals)
    }
  })
  names(cols) <- keys
  tibble::as_tibble(cols)
}

# S3 result object -----------------------------------------------------------

new_clb <- function(data, meta = list(), facets = NULL) {
  structure(
    list(meta = meta, data = data, facets = facets),
    class = "clb"
  )
}

#' @export
print.clb <- function(x, ...) {
  total <- x$meta$total %||% NA
  cli::cli_text("{.cls clb} result: {nrow(x$data)} rows (total: {total})")
  print(x$data, ...)
  if (length(x$facets)) {
    cli::cli_text("{.emph facets}: {paste(names(x$facets), collapse = ', ')}")
  }
  invisible(x)
}
