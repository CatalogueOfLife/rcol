# Live integration tests. Skipped on CRAN and when offline; they hit the real
# public ChecklistBank API.

test_that("name matching works against a fixed COL release", {
  skip_on_cran()
  skip_if_offline("api.checklistbank.org")

  res <- clb_match("Panthera leo", dataset = "3LR")
  expect_s3_class(res, "tbl_df")
  expect_identical(nrow(res), 1L)
  expect_true(res$match)
  expect_identical(res$status, "accepted")
  expect_match(res$name, "Panthera leo")
})

test_that("col_match resolves the latest release and matches", {
  skip_on_cran()
  skip_if_offline("api.checklistbank.org")
  withr::defer(col_cache_clear())

  col_cache_clear()
  res <- col_match("Panthera leo")
  expect_s3_class(res, "tbl_df")
  expect_true(res$match)
  expect_match(res$name, "Panthera leo")
  expect_type(col_key(), "integer")
})

test_that("name parsing atomises a name", {
  skip_on_cran()
  skip_if_offline("api.checklistbank.org")

  res <- clb_parse_name("Abies alba Mill.")
  expect_s3_class(res, "tbl_df")
  expect_identical(res$genus[[1]], "Abies")
  expect_identical(res$specificEpithet[[1]], "alba")
})

test_that("dataset search returns a clb object with data", {
  skip_on_cran()
  skip_if_offline("api.checklistbank.org")

  res <- clb_dataset_search("mammal", max = 5)
  expect_s3_class(res, "clb")
  expect_s3_class(res$data, "tbl_df")
  expect_true(nrow(res$data) >= 1)
})

test_that("tree roots and children resolve", {
  skip_on_cran()
  skip_if_offline("api.checklistbank.org")

  roots <- clb_tree(dataset = "3LR")
  expect_s3_class(roots, "tbl_df")
  expect_true(nrow(roots) >= 1)

  kids <- clb_children(roots$id[1], dataset = "3LR", max = 5)
  expect_s3_class(kids, "tbl_df")
})
