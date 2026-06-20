# Pure helper functions, no network required.

test_that("clb_query drops NULLs and lowercases logicals", {
  q <- clb_query(a = 1, b = NULL, c = TRUE, d = FALSE, e = "x")
  expect_named(q, c("a", "c", "d", "e"))
  expect_identical(q$c, "true")
  expect_identical(q$d, "false")
  expect_identical(q$e, "x")
})

test_that("clb_coerce_scalar turns NULL/empty into NA and keeps type", {
  expect_identical(
    clb_coerce_scalar(list("a", NULL, "b")),
    c("a", NA, "b")
  )
  out <- clb_coerce_scalar(list(1L, NULL, 3L))
  expect_true(is.na(out[2]))
  expect_length(out, 3)
})

test_that("clb_records_to_tibble builds atomic and list columns", {
  recs <- list(
    list(id = "a", n = 1L, tags = list("x", "y")),
    list(id = "b", n = 2L)
  )
  tb <- clb_records_to_tibble(recs)
  expect_s3_class(tb, "tbl_df")
  expect_identical(tb$id, c("a", "b"))
  expect_identical(tb$n, c(1L, 2L))
  expect_true(is.list(tb$tags))
  # missing nested value becomes NULL in the list column
  expect_null(tb$tags[[2]])
})

test_that("empty record list yields an empty tibble", {
  expect_identical(nrow(clb_records_to_tibble(list())), 0L)
})

test_that("clb_flatten_usage hoists name fields and keeps name list-col", {
  u <- list(
    id = "X1",
    status = "accepted",
    label = "Aus bus L.",
    parentId = "P",
    name = list(scientificName = "Aus bus", authorship = "L.", rank = "species")
  )
  row <- clb_flatten_usage(u)
  expect_identical(row$id, "X1")
  expect_identical(row$scientific_name, "Aus bus")
  expect_identical(row$authorship, "L.")
  expect_identical(row$rank, "species")
  expect_identical(row$parent_id, "P")
  expect_true(is.list(row$name))
})

test_that("clb_match_row handles matched and unmatched responses", {
  matched <- clb_match_row(list(
    match = TRUE, type = "exact",
    usage = list(id = "4CGXP", name = "Panthera leo", status = "accepted")
  ))
  expect_true(matched$match)
  expect_identical(matched$usage_id, "4CGXP")
  expect_identical(matched$match_type, "exact")

  none <- clb_match_row(list(match = FALSE, type = "none"))
  expect_false(none$match)
  expect_true(is.na(none$usage_id))
})

test_that("clb_as_usage_list flattens nested groups", {
  flat <- clb_as_usage_list(list(
    list(id = "1", name = list(scientificName = "A")),
    list(
      list(id = "2", name = list(scientificName = "B")),
      list(id = "3", name = list(scientificName = "C"))
    )
  ))
  expect_length(flat, 3)
  expect_identical(vapply(flat, function(x) x$id, character(1)), c("1", "2", "3"))
})
