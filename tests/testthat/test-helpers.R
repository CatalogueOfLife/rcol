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
  expect_identical(names(row)[length(row)], "name")
})

test_that("clb_flatten_usage includes all usage fields", {
  u <- list(
    id = "X1",
    status = "accepted",
    origin = "source",
    datasetKey = 316441L,
    sectorKey = 1508L,
    verbatimSourceKey = 345992150L,
    merged = FALSE,
    link = "https://example.org/X1",
    identifier = list("taxref:644245", "inat:41964"),
    referenceIds = list("r1", "r2"),
    scrutinizer = "W. Wozencraft",
    scrutinizerDate = "2024-06-25",
    environments = list("terrestrial"),
    name = list(scientificName = "Aus bus")
  )
  row <- clb_flatten_usage(u)
  expect_identical(row$origin, "source")
  expect_identical(row$dataset_key, 316441L)
  expect_identical(row$sector_key, 1508L)
  expect_identical(row$verbatim_source_key, 345992150L)
  expect_false(row$merged)
  expect_identical(row$link, "https://example.org/X1")
  expect_identical(row$identifier, list(c("taxref:644245", "inat:41964")))
  expect_identical(row$reference_ids, list(c("r1", "r2")))
  expect_identical(row$scrutinizer, "W. Wozencraft")
  expect_identical(row$scrutinizer_date, "2024-06-25")
  expect_identical(row$environments, list("terrestrial"))
  # absent fields become NA
  expect_true(is.na(row$sector_mode))
  expect_true(is.na(row$remarks))
  expect_true(is.na(row$accepted_id))
})

test_that("clb_flatten_usage exposes the accepted name of a synonym", {
  u <- list(
    id = "S1",
    status = "synonym",
    origin = "source",
    accepted = list(id = "X1", name = list(scientificName = "Aus bus")),
    name = list(scientificName = "Aus cus")
  )
  row <- clb_flatten_usage(u)
  expect_identical(row$accepted_id, "X1")
  expect_identical(row$accepted_name, "Aus bus")
  expect_true(is.na(row$scrutinizer))
})

test_that("clb_flatten_usage falls back to parentId for a synonym's accepted_id", {
  for (st in c("synonym", "ambiguous synonym", "misapplied")) {
    row <- clb_flatten_usage(list(id = "S1", status = st, parentId = "X1"))
    expect_identical(row$accepted_id, "X1")
    expect_true(is.na(row$accepted_name))
  }
  # an accepted taxon's parent is not its accepted usage
  taxon <- clb_flatten_usage(list(id = "X1", status = "accepted", parentId = "P"))
  expect_true(is.na(taxon$accepted_id))
  # missing status does not error
  expect_true(is.na(clb_flatten_usage(list(id = "Y", parentId = "P"))$accepted_id))
})

test_that("flattened usages with missing array fields bind into a tibble", {
  rows <- list(
    clb_flatten_usage(list(id = "A", identifier = list("x:1"))),
    clb_flatten_usage(list(id = "B"))
  )
  tb <- clb_bind_rows(rows)
  expect_identical(nrow(tb), 2L)
  expect_true(is.list(tb$identifier))
  expect_identical(tb$identifier[[1]], "x:1")
  expect_null(tb$identifier[[2]])
  expect_identical(tb$origin, c(NA_character_, NA_character_))
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

test_that("clb_synonymy_to_tibble ignores heterotypicGroups and tags misapplied", {
  syn <- function(id) list(id = id, status = "synonym",
                           name = list(scientificName = paste("Aus", id)))
  tb <- clb_synonymy_to_tibble(list(
    homotypic = list(syn("H1")),
    heterotypic = list(syn("S1"), syn("S2")),
    heterotypicGroups = list(list(syn("S1")), list(syn("S2"))),
    misapplied = list(syn("M1"))
  ))
  expect_identical(tb$id, c("H1", "S1", "S2", "M1"))
  expect_identical(
    tb$synonym_type,
    c("homotypic", "heterotypic", "heterotypic", "misapplied")
  )
  expect_identical(names(tb)[1], "synonym_type")

  expect_identical(nrow(clb_synonymy_to_tibble(list())), 0L)
  expect_identical(nrow(clb_synonymy_to_tibble(NULL)), 0L)
})
