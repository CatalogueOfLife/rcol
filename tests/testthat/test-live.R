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

test_that("usage info returns the full usage document", {
  skip_on_cran()
  skip_if_offline("api.checklistbank.org")

  info <- clb_usage_info("6JBVG", dataset = "3LR")
  expect_s3_class(info, "clb_usage_info")
  expect_identical(info$usage$scientific_name, "Flustra foliacea")
  expect_identical(info$group, "otheranimals")
  expect_true(nrow(info$classification) >= 1)
  expect_true(nrow(info$vernacular_names) >= 1)
  expect_true(nrow(info$references) >= 1)
})

test_that("taxon subresources resolve", {
  skip_on_cran()
  skip_if_offline("api.checklistbank.org")

  dist <- clb_distribution("4CGXP", dataset = "3LR")
  expect_true("Africa" %in% dist$area_name)

  for (f in list(clb_interaction, clb_media, clb_property, clb_relation)) {
    expect_s3_class(f("4CGXP", dataset = "3LR"), "tbl_df")
  }
})

test_that("usage search returns all usage fields", {
  skip_on_cran()
  skip_if_offline("api.checklistbank.org")

  res <- clb_usage_search("Panthera leo", dataset = "3LR", max = 3)
  expect_s3_class(res$data, "tbl_df")
  expect_true(all(c("origin", "sector_key", "sector_dataset_key",
                    "reference_ids") %in% names(res$data)))
  expect_false(anyNA(res$data$origin))
})
