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
      list(id = 2L, area = list(gazetteer = "text", name = "Africa")),
      list(id = 3L, area = list(gazetteer = "iso", id = "BE-VLG", name = "Flemish Region")),
      list(id = 4L, area = list(gazetteer = "tdwg", id = "BGM", name = "Belgium"))
    )
  })
  tb <- clb_distribution("4CGXP", dataset = "3LR")
  expect_identical(seen, c("dataset", "3LR", "taxon", "4CGXP", "distribution"))
  expect_identical(
    names(tb),
    c("id", "area_gazetteer", "area_id", "area_name", "country_code",
      "establishmentMeans")
  )
  expect_identical(tb$area_gazetteer, c("iso", "text", "iso", "tdwg"))
  expect_identical(tb$area_id, c("DE", NA, "BE-VLG", "BGM"))
  expect_identical(tb$area_name, c("Germany", "Africa", "Flemish Region", "Belgium"))
  expect_identical(tb$country_code, c("DE", NA, "BE", NA))
})

test_that("clb_distribution adds reference citations, one request per reference", {
  calls <- list()
  local_mocked_bindings(clb_get = function(...) {
    path <- unlist(list(...))
    calls[[length(calls) + 1L]] <<- path
    if (path[[3]] == "reference") {
      return(list(id = path[[4]], citation = paste("Citation", path[[4]])))
    }
    list(
      list(id = 1L, area = list(gazetteer = "text", name = "A"), referenceId = "r1", year = 2014L),
      list(id = 2L, area = list(gazetteer = "text", name = "B"), referenceId = "r1"),
      list(id = 3L, area = list(gazetteer = "text", name = "C"))
    )
  })
  tb <- clb_distribution("T1", dataset = "7033")
  ref_calls <- Filter(function(p) p[[3]] == "reference", calls)
  expect_identical(ref_calls, list(c("dataset", "7033", "reference", "r1")))
  expect_identical(tb$reference_citation, c("Citation r1", "Citation r1", NA))
  expect_identical(match("reference_citation", names(tb)),
                   match("referenceId", names(tb)) + 1L)

  calls <- list()
  tb <- clb_distribution("T1", dataset = "7033", citations = FALSE)
  expect_length(calls, 1L)
  expect_false("reference_citation" %in% names(tb))
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
