# col_key() resolution/caching and the col_*() shortcuts.

test_that("col_key resolves once and caches the integer key", {
  calls <- 0L
  local_mocked_bindings(
    clb_get = function(...) {
      calls <<- calls + 1L
      list(key = 315192L, alias = "COL26.5 XR")
    }
  )
  withr::defer(col_cache_clear())

  col_cache_clear()
  expect_identical(col_key(), 315192L)
  expect_identical(col_key(), 315192L) # served from cache
  expect_identical(calls, 1L)

  # refresh forces a new resolution
  col_key(refresh = TRUE)
  expect_identical(calls, 2L)
})

test_that("col_* shortcuts delegate to clb_* with the pinned key", {
  withr::defer(col_cache_clear())
  local_mocked_bindings(col_key = function(...) 999L)

  seen <- NULL
  local_mocked_bindings(
    clb_usage = function(id, dataset = "3LXR", .raw = FALSE) {
      seen <<- list(id = id, dataset = dataset)
      tibble::tibble(id = id)
    }
  )
  col_usage("4CGXP")
  expect_identical(seen$dataset, 999L)
  expect_identical(seen$id, "4CGXP")
})

test_that("col_key aborts when the release cannot be resolved", {
  withr::defer(col_cache_clear())
  local_mocked_bindings(clb_get = function(...) list(alias = "x"))
  col_cache_clear()
  expect_error(col_key(), "Could not resolve")
})
