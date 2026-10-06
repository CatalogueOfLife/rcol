# clb_usage_info() response shaping, with the HTTP layer mocked.

usage_info_fixture <- function() {
  list(
    usage = list(
      id = "6JBVG", status = "accepted", parentId = "84NQF",
      label = "Flustra foliacea (Linnaeus, 1758)",
      name = list(scientificName = "Flustra foliacea",
                  authorship = "(Linnaeus, 1758)", rank = "species")
    ),
    classification = list(
      list(id = "CS5HF", name = "Eukaryota", rank = "domain"),
      list(id = "84NQF", name = "Flustra", rank = "genus")
    ),
    group = "otheranimals",
    source = list(id = 1L, sourceId = "urn:lsid:x"),
    synonyms = list(
      heterotypic = list(list(id = "S1", name = list(scientificName = "Bus"))),
      heterotypicGroups = list(list(list(id = "S1", name = list(scientificName = "Bus"))))
    ),
    vernacularNames = list(
      list(id = 1L, name = "Hornwrack", language = "eng"),
      list(id = 2L, name = "Blätter Moostierchen", language = "deu")
    ),
    typeMaterial = list(N1 = list(list(id = "T1", nameId = "N1", status = "holotype"))),
    references = list(
      r1 = list(id = "r1", citation = "Ref one."),
      r2 = list(id = "r2", citation = "Ref two.")
    ),
    treatment = list(format = "html", document = "<p>Desc</p>")
  )
}

test_that("clb_usage_info calls the taxon info endpoint and shapes the result", {
  seen <- NULL
  local_mocked_bindings(clb_get = function(...) {
    seen <<- unlist(list(...))
    usage_info_fixture()
  })

  info <- clb_usage_info("6JBVG", dataset = "3LR")
  expect_identical(seen, c("dataset", "3LR", "taxon", "6JBVG", "info"))
  expect_s3_class(info, "clb_usage_info")
  expect_named(info, c(
    "usage", "group", "classification", "synonyms", "vernacular_names",
    "distributions", "media", "name_relations", "properties",
    "concept_relations", "species_interactions", "estimates", "type_material",
    "references", "names", "taxa", "decisions", "published_in", "source",
    "verbatim"
  ))

  expect_identical(info$usage$scientific_name, "Flustra foliacea")
  expect_identical(info$group, "otheranimals")
  expect_identical(info$classification$id, c("CS5HF", "84NQF"))
  expect_identical(info$synonyms$id, "S1")
  expect_identical(info$vernacular_names$language, c("eng", "deu"))
  expect_identical(info$type_material$nameId, "N1")
  expect_identical(info$references$id, c("r1", "r2"))
  expect_identical(info$source$sourceId, "urn:lsid:x")

  # absent components keep their slot with an empty value
  expect_s3_class(info$distributions, "tbl_df")
  expect_identical(nrow(info$distributions), 0L)
  expect_null(info$verbatim)

  expect_no_error(cli::cli_fmt(print(info)))
  expect_match(
    paste(cli::cli_fmt(print(info)), collapse = "\n"),
    "vernacular_names: 2"
  )
})

test_that("clb_usage_info returns the raw response with .raw = TRUE", {
  local_mocked_bindings(clb_get = function(...) usage_info_fixture())
  expect_identical(clb_usage_info("6JBVG", .raw = TRUE), usage_info_fixture())
})
