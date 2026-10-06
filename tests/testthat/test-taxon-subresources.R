# Taxon subresource functions, with the HTTP layer mocked.

test_that("list-valued taxon subresources call the right endpoint", {
  fns <- list(
    interaction = clb_interaction,
    media = clb_media,
    property = clb_property,
    relation = clb_relation
  )
  for (resource in names(fns)) {
    seen <- NULL
    local_mocked_bindings(clb_get = function(...) {
      seen <<- unlist(list(...))
      list(list(id = "a", type = "x"), list(id = "b", type = "y"))
    })
    tb <- fns[[resource]]("T1", dataset = "3LR")
    expect_identical(seen, c("dataset", "3LR", "taxon", "T1", resource))
    expect_s3_class(tb, "tbl_df")
    expect_identical(tb$id, c("a", "b"))
  }
})

test_that("empty subresources give zero-row tibbles", {
  local_mocked_bindings(clb_get = function(...) list())
  expect_identical(nrow(clb_media("T1")), 0L)
  expect_identical(nrow(clb_distribution("T1")), 0L)
})

test_that("clb_distribution hoists the nested area", {
  seen <- NULL
  local_mocked_bindings(clb_get = function(...) {
    seen <<- unlist(list(...))
    list(
      list(id = 1L, area = list(gazetteer = "iso", id = "DE", name = "Germany"),
           establishmentMeans = "native"),
      list(id = 2L, area = list(gazetteer = "text", name = "Africa"))
    )
  })
  tb <- clb_distribution("4CGXP", dataset = "3LR")
  expect_identical(seen, c("dataset", "3LR", "taxon", "4CGXP", "distribution"))
  expect_identical(
    names(tb),
    c("id", "area_gazetteer", "area_id", "area_name", "establishmentMeans")
  )
  expect_identical(tb$area_gazetteer, c("iso", "text"))
  expect_identical(tb$area_id, c("DE", NA))
  expect_identical(tb$area_name, c("Germany", "Africa"))
})

test_that("col_* subresource shortcuts pass the pinned key", {
  withr::defer(col_cache_clear())
  local_mocked_bindings(col_key = function(...) 999L)
  seen <- NULL
  local_mocked_bindings(clb_get = function(...) {
    seen <<- unlist(list(...))
    list()
  })
  for (f in c("distribution", "interaction", "media", "property", "relation")) {
    get(paste0("col_", f))("T1")
    expect_identical(seen, c("dataset", "999", "taxon", "T1", f))
  }
})
