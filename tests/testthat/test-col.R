# COL release resolution. Monthly cases are pure; annual cases mock the
# network call to clb_col_releases().

test_that("monthly release aliases are stable", {
  expect_identical(clb_col_release("monthly"), "3LR")
  expect_identical(clb_col_release("monthly", extended = TRUE), "3LXR")
})

test_that("annual release picks the highest COL year", {
  local_mocked_bindings(
    clb_col_releases = function(...) {
      tibble::tibble(alias = c("COL23", "COL24", "COL25", "COL22 XR"))
    }
  )
  expect_identical(clb_col_release("annual"), "COL25")
})

test_that("annual extended release matches the ' XR' suffix", {
  local_mocked_bindings(
    clb_col_releases = function(...) {
      tibble::tibble(alias = c("COL24", "COL25", "COL24 XR", "COL25 XR"))
    }
  )
  expect_identical(clb_col_release("annual", extended = TRUE), "COL25 XR")
})

test_that("missing annual extended release warns and returns NA", {
  local_mocked_bindings(
    clb_col_releases = function(...) tibble::tibble(alias = c("COL24", "COL25"))
  )
  expect_warning(out <- clb_col_release("annual", extended = TRUE))
  expect_true(is.na(out))
})
