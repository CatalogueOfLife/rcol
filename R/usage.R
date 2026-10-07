# Name usages, taxa and related information ----------------------------------

# Taxonomic status values (as serialised by the API) of synonym usages.
clb_synonym_status <- c("synonym", "ambiguous synonym", "misapplied")

# Hoist the most useful name fields out of the nested `name` object so a usage
# becomes a tidy single row; keep the full name object as a list-column.
# All NameUsageBase fields are included, plus the Taxon-only fields (NA for
# synonyms) and the accepted name of a synonym (NA for taxa). Array fields
# become list-columns of vectors. Some endpoints (e.g. taxon synonyms) omit the
# nested `accepted` usage; a synonym's parent is its accepted usage, so
# `accepted_id` falls back to `parentId` then.
clb_flatten_usage <- function(u) {
  nm <- u$name %||% list()
  acc <- u$accepted %||% list()
  is_synonym <- isTRUE(u$status %in% clb_synonym_status)
  list(
    id = u$id %||% NA_character_,
    scientific_name = nm$scientificName %||% u$name$scientificName %||% NA_character_,
    authorship = nm$authorship %||% NA_character_,
    rank = nm$rank %||% NA_character_,
    status = u$status %||% NA_character_,
    label = u$label %||% NA_character_,
    parent_id = u$parentId %||% NA_character_,
    extinct = u$extinct %||% NA,
    accepted_id = acc$id %||% (if (is_synonym) u$parentId) %||% NA_character_,
    accepted_name = acc$name$scientificName %||% NA_character_,
    origin = u$origin %||% NA_character_,
    dataset_key = u$datasetKey %||% NA_integer_,
    sector_key = u$sectorKey %||% NA_integer_,
    sector_mode = u$sectorMode %||% NA_character_,
    verbatim_key = u$verbatimKey %||% NA_integer_,
    verbatim_source_key = u$verbatimSourceKey %||% NA_integer_,
    merged = u$merged %||% NA,
    name_phrase = u$namePhrase %||% NA_character_,
    according_to = u$accordingTo %||% NA_character_,
    according_to_id = u$accordingToId %||% NA_character_,
    link = u$link %||% NA_character_,
    remarks = u$remarks %||% NA_character_,
    identifier = list(unlist(u$identifier)),
    reference_ids = list(unlist(u$referenceIds)),
    scrutinizer = u$scrutinizer %||% NA_character_,
    scrutinizer_id = u$scrutinizerID %||% NA_character_,
    scrutinizer_date = u$scrutinizerDate %||% NA_character_,
    temporal_range_start = u$temporalRangeStart %||% NA_character_,
    temporal_range_end = u$temporalRangeEnd %||% NA_character_,
    ordinal = u$ordinal %||% NA_integer_,
    environments = list(unlist(u$environments)),
    name = list(nm)
  )
}

# Recursively collect usage-like objects from (possibly nested) JSON nodes.
clb_as_usage_list <- function(x) {
  if (is.null(x)) return(list())
  if (!is.null(names(x)) && any(c("name", "id") %in% names(x))) return(list(x))
  if (is.list(x)) return(unlist(lapply(x, clb_as_usage_list), recursive = FALSE))
  list()
}

# Convert a Synonymy object into a tibble of synonym usages tagged by type.
# `heterotypicGroups` repeats the `heterotypic` synonyms grouped by homotypic
# group, so it is ignored here to avoid duplicates.
clb_synonymy_to_tibble <- function(syn) {
  tag <- function(lst, type) lapply(clb_as_usage_list(lst), function(s) {
    r <- clb_flatten_usage(s)
    r$synonym_type <- type
    r
  })
  rows <- c(
    tag(syn$homotypic, "homotypic"),
    tag(syn$heterotypic, "heterotypic"),
    tag(syn$misapplied, "misapplied")
  )
  if (!length(rows)) return(tibble::tibble())
  out <- clb_bind_rows(rows)
  out[c("synonym_type", setdiff(names(out), "synonym_type"))]
}

# Turn an id-keyed map of records (e.g. references) into a tibble; each record
# carries its own `id`, so the map keys are dropped.
clb_map_to_tibble <- function(m) {
  clb_records_to_tibble(unname(m %||% list()))
}

# Fetch a list-valued taxon subresource (e.g. `distribution`, `media`) as a
# tibble, one row per record.
clb_taxon_records <- function(id, dataset, resource, .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), resource)
  if (isTRUE(.raw)) return(resp)
  clb_records_to_tibble(resp)
}

# Distribution records as a tibble, with the nested `area` object replaced by
# `area_gazetteer`, `area_id` and `area_name` columns.
clb_distributions_to_tibble <- function(records) {
  out <- clb_records_to_tibble(records)
  idx <- match("area", names(out))
  if (is.na(idx)) return(out)
  area_field <- function(f) {
    as.character(clb_coerce_scalar(lapply(out$area, function(a) a[[f]])))
  }
  hoisted <- list(
    area_gazetteer = area_field("gazetteer"),
    area_id = area_field("id"),
    area_name = area_field("name")
  )
  tibble::as_tibble(c(out[seq_len(idx - 1L)], hoisted, out[-seq_len(idx)]))
}

#' Get a name usage (taxon or synonym) by id
#'
#' @param id Usage id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A one-row [tibble][tibble::tibble] with the usage's `id`,
#'   `scientific_name`, `authorship`, `rank`, `status`, `label`, `parent_id`,
#'   `extinct`, the accepted usage of a synonym (`accepted_id`,
#'   `accepted_name`), its provenance (`origin`, `dataset_key`, `sector_key`,
#'   `sector_mode`, `verbatim_key`, `verbatim_source_key`, `merged`), further
#'   usage fields (`name_phrase`, `according_to`, `according_to_id`, `link`,
#'   `remarks`, `scrutinizer`, `scrutinizer_id`, `scrutinizer_date`,
#'   `temporal_range_start`, `temporal_range_end`, `ordinal`), the list-columns
#'   `identifier`, `reference_ids` and `environments`, and the full nested
#'   `name` as a list-column. Fields that do not apply, such as `scrutinizer`
#'   for a synonym, are `NA`.
#' @seealso [clb_usage_search()], [clb_classification()], [clb_synonyms()]
#' @export
#' @examples
#' \dontrun{
#' clb_usage("4CGXP", dataset = "3LR")
#' }
clb_usage <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "nameusage", as.character(id))
  if (isTRUE(.raw)) return(resp)
  tibble::as_tibble(clb_flatten_usage(resp))
}

#' Full information about a name usage
#'
#' Fetches the complete `UsageInfo` document for a usage in one request: the
#' usage itself together with its classification, synonymy, vernacular names,
#' distributions, media, references, type material and other related data, as
#' shown on a ChecklistBank taxon page. Works for accepted taxa and synonyms.
#'
#' @param id Usage id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a `clb_usage_info` list?
#'
#' @return A `clb_usage_info` object: a named list whose elements are always
#'   present, empty when the API returns no data for them:
#'   * `usage`: a one-row [tibble][tibble::tibble] as returned by [clb_usage()].
#'   * `group`: the informal taxonomic group, e.g. `"chordates"`.
#'   * `classification`, `synonyms`, `vernacular_names`, `distributions`,
#'     `media`, `name_relations`, `properties`, `concept_relations`,
#'     `species_interactions`, `estimates`, `type_material`: tibbles, one row
#'     per record. `synonyms` and `distributions` are shaped as in
#'     [clb_synonyms()] and [clb_distribution()].
#'   * `references`, `names`, `taxa`, `decisions`: tibbles of the records
#'     referred to by id from the other elements.
#'   * `published_in`, `source`, `verbatim`: nested lists, or `NULL` when
#'     absent.
#'
#'   The usage's treatment document is not included; use `.raw = TRUE` to get
#'   it.
#' @seealso [clb_usage()], [clb_classification()], [clb_synonyms()],
#'   [clb_vernacular()]
#' @export
#' @examples
#' \dontrun{
#' info <- clb_usage_info("6JBVG", dataset = "3LR")
#' info
#' info$vernacular_names
#' }
clb_usage_info <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), "info")
  if (isTRUE(.raw)) return(resp)
  structure(
    list(
      usage = tibble::as_tibble(clb_flatten_usage(resp$usage %||% list())),
      group = resp$group %||% NA_character_,
      classification = clb_records_to_tibble(resp$classification),
      synonyms = clb_synonymy_to_tibble(resp$synonyms),
      vernacular_names = clb_records_to_tibble(resp$vernacularNames),
      distributions = clb_distributions_to_tibble(resp$distributions),
      media = clb_records_to_tibble(resp$media),
      name_relations = clb_records_to_tibble(resp$nameRelations),
      properties = clb_records_to_tibble(resp$properties),
      concept_relations = clb_records_to_tibble(resp$conceptRelations),
      species_interactions = clb_records_to_tibble(resp$speciesInteractions),
      estimates = clb_records_to_tibble(resp$estimates),
      type_material = clb_records_to_tibble(
        unlist(unname(resp$typeMaterial), recursive = FALSE)
      ),
      references = clb_map_to_tibble(resp$references),
      names = clb_map_to_tibble(resp$names),
      taxa = clb_map_to_tibble(resp$taxa),
      decisions = clb_map_to_tibble(resp$decisions),
      published_in = resp$publishedIn,
      source = resp$source,
      verbatim = resp$verbatim
    ),
    class = "clb_usage_info"
  )
}

#' @export
print.clb_usage_info <- function(x, ...) {
  u <- x$usage
  cli::cli_text(
    "{.cls clb_usage_info} {u$label} [{u$status}, {u$rank}, group: {x$group}]"
  )
  counts <- vapply(
    x, function(el) if (is.data.frame(el)) nrow(el) else 0L, integer(1)
  )
  counts <- counts[setdiff(names(counts), "usage")]
  counts <- counts[counts > 0L]
  if (length(counts)) {
    lines <- paste0(names(counts), ": ", counts)
    cli::cli_bullets(structure(lines, names = rep("*", length(lines))))
  }
  invisible(x)
}

#' Full-text search of name usages
#'
#' Searches name usages within a dataset (defaults to the latest extended COL
#' release). The accepted/synonym usage fields are hoisted to top-level columns
#' as in [clb_usage()], including `origin` and the sector keys; the taxonomic
#' classification and full name object are kept as list-columns.
#'
#' @param q Free-text query. Optional (omit to browse with filters only).
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param rank Filter by rank (e.g. `"species"`).
#' @param status Filter by taxonomic status (e.g. `"accepted"`, `"synonym"`).
#' @param ... Further query parameters forwarded to the search endpoint
#'   (e.g. `extinct`, `nomCode`, `minRank`, `maxRank`, `type`).
#' @param limit Page size per request.
#' @param max Maximum number of usages to return. Use `Inf` to fetch all.
#'
#' @return A `clb` object: a list with `$data` (a [tibble][tibble::tibble] of
#'   usages) and `$meta` (with `total`). Besides the columns described in
#'   [clb_usage()], `$data` has `group`, `sector_dataset_key`,
#'   `sector_publisher_key`, the list-columns `secondary_source_keys` and
#'   `secondary_source_groups`, and `classification`.
#' @seealso [clb_match()], [clb_suggest()], [clb_usage()]
#' @export
#' @examples
#' \dontrun{
#' clb_usage_search("Felidae")
#' clb_usage_search("Panthera", rank = "species", status = "accepted")
#' }
clb_usage_search <- function(q = NULL, dataset = "3LXR", rank = NULL,
                             status = NULL, ..., limit = 50L, max = limit) {
  paged <- clb_get_paged(
    "dataset", as.character(dataset), "nameusage", "search",
    query = clb_query(q = q, rank = rank, status = status, ...),
    limit = limit, max = max
  )
  rows <- lapply(paged$result, function(w) {
    row <- clb_flatten_usage(w$usage %||% list())
    row$group <- w$group %||% NA_character_
    row$sector_dataset_key <- w$sectorDatasetKey %||% NA_integer_
    row$sector_publisher_key <- w$sectorPublisherKey %||% NA_character_
    row$secondary_source_keys <- list(unlist(w$secondarySourceKeys))
    row$secondary_source_groups <- list(unlist(w$secondarySourceGroups))
    row$classification <- list(w$classification %||% list())
    row
  })
  new_clb(data = clb_bind_rows(rows), meta = list(total = paged$total))
}

#' @rdname clb_usage_search
#' @export
clb_search <- clb_usage_search

#' Autocomplete suggestions for name usages
#'
#' Fast prefix-based suggestions, suitable for type-ahead lookups.
#'
#' @param q Partial name to complete.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param ... Further query parameters (e.g. `rank`, `status`).
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of suggestions with columns such as
#'   `suggestion`, `usageId`, `rank`, `status` and `group`.
#' @seealso [clb_usage_search()]
#' @export
#' @examples
#' \dontrun{
#' clb_suggest("Panth")
#' }
clb_suggest <- function(q, dataset = "3LXR", ..., .raw = FALSE) {
  resp <- clb_get(
    "dataset", as.character(dataset), "nameusage", "suggest",
    query = clb_query(q = q, ...)
  )
  if (isTRUE(.raw)) return(resp)
  clb_records_to_tibble(resp)
}

#' Taxonomic classification (lineage) of a taxon
#'
#' Returns the ordered parent chain from the root down to the taxon.
#'
#' @param id Taxon id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of ancestors, one row per rank, with
#'   columns `id`, `name`, `authorship`, `rank` and `labelHtml`.
#' @seealso [clb_usage()], [clb_children()]
#' @export
#' @examples
#' \dontrun{
#' clb_classification("4CGXP", dataset = "3LR")
#' }
clb_classification <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), "classification")
  if (isTRUE(.raw)) return(resp)
  clb_records_to_tibble(resp)
}

#' Synonyms of a taxon
#'
#' @param id Taxon id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of synonym usages with a `synonym_type`
#'   column (`"homotypic"`, `"heterotypic"` or `"misapplied"`) and the usual
#'   flattened usage columns. Zero rows when the taxon has no synonyms.
#' @seealso [clb_usage()]
#' @export
#' @examples
#' \dontrun{
#' clb_synonyms("6DBT", dataset = "3LR")
#' }
clb_synonyms <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), "synonyms")
  if (isTRUE(.raw)) return(resp)
  clb_synonymy_to_tibble(resp)
}

#' Vernacular (common) names
#'
#' Looks up vernacular names either for a single taxon (when `id` is given) or
#' across a dataset by free-text query.
#'
#' @param id Optional taxon id. When supplied, returns the vernacular names of
#'   that taxon; otherwise performs a dataset-wide vernacular search using `q`.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param q Free-text query for the dataset-wide search (ignored when `id` is
#'   supplied).
#' @param lang Optional ISO language filter (e.g. `"eng"`, `"deu"`).
#' @param ... Further query parameters.
#' @param limit Page size for the dataset-wide search.
#' @param max Maximum rows for the dataset-wide search.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of vernacular names with columns such as
#'   `name`, `latin`, `language` and `taxonID`.
#' @export
#' @examples
#' \dontrun{
#' clb_vernacular(id = "4CGXP", dataset = "3LR")
#' clb_vernacular(q = "lion", lang = "eng")
#' }
clb_vernacular <- function(id = NULL, dataset = "3LXR", q = NULL, lang = NULL,
                           ..., limit = 50L, max = limit, .raw = FALSE) {
  if (!is.null(id)) {
    resp <- clb_get(
      "dataset", as.character(dataset), "taxon", as.character(id), "vernacular",
      query = clb_query(lang = lang)
    )
    if (isTRUE(.raw)) return(resp)
    return(clb_records_to_tibble(resp))
  }
  paged <- clb_get_paged(
    "dataset", as.character(dataset), "vernacular",
    query = clb_query(q = q, lang = lang, ...),
    limit = limit, max = max
  )
  clb_records_to_tibble(paged$result)
}

#' Distributions of a taxon
#'
#' @param id Taxon id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of distribution records. The nested area
#'   is returned as `area_gazetteer`, `area_id` and `area_name` columns,
#'   alongside fields such as `establishmentMeans`, `threatStatus` and
#'   `referenceId`. Zero rows when the taxon has no distributions.
#' @seealso [clb_usage_info()]
#' @export
#' @examples
#' \dontrun{
#' clb_distribution("4CGXP", dataset = "3LR")
#' }
clb_distribution <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), "distribution")
  if (isTRUE(.raw)) return(resp)
  clb_distributions_to_tibble(resp)
}

#' Species interactions of a taxon
#'
#' @inheritParams clb_distribution
#'
#' @return A [tibble][tibble::tibble] of interactions with columns such as
#'   `type`, `relatedTaxonId`, `relatedTaxonScientificName` and `referenceId`.
#'   Zero rows when the taxon has no interactions.
#' @seealso [clb_relation()], [clb_usage_info()]
#' @export
#' @examples
#' \dontrun{
#' clb_interaction("4CGXP", dataset = "3LR")
#' }
clb_interaction <- function(id, dataset = "3LXR", .raw = FALSE) {
  clb_taxon_records(id, dataset, "interaction", .raw = .raw)
}

#' Media of a taxon
#'
#' @inheritParams clb_distribution
#'
#' @return A [tibble][tibble::tibble] of media items with columns such as
#'   `url`, `thumbnail`, `type`, `title`, `license` and `capturedBy`. Zero rows
#'   when the taxon has no media.
#' @seealso [clb_usage_info()]
#' @export
#' @examples
#' \dontrun{
#' clb_media("4CGXP", dataset = "3LR")
#' }
clb_media <- function(id, dataset = "3LXR", .raw = FALSE) {
  clb_taxon_records(id, dataset, "media", .raw = .raw)
}

#' Properties of a taxon
#'
#' Free-form taxon properties such as traits or descriptive facts.
#'
#' @inheritParams clb_distribution
#'
#' @return A [tibble][tibble::tibble] of properties with columns such as
#'   `property`, `value`, `referenceId` and `ordinal`. Zero rows when the
#'   taxon has no properties.
#' @seealso [clb_usage_info()]
#' @export
#' @examples
#' \dontrun{
#' clb_property("4CGXP", dataset = "3LR")
#' }
clb_property <- function(id, dataset = "3LXR", .raw = FALSE) {
  clb_taxon_records(id, dataset, "property", .raw = .raw)
}

#' Taxon concept relations of a taxon
#'
#' Relations between this taxon concept and others, e.g. `"equals"`,
#' `"includes"` or `"overlaps"`.
#'
#' @inheritParams clb_distribution
#'
#' @return A [tibble][tibble::tibble] of relations with columns such as
#'   `type`, `relatedTaxonId` and `referenceId`. Zero rows when the taxon has
#'   no concept relations.
#' @seealso [clb_interaction()], [clb_usage_info()]
#' @export
#' @examples
#' \dontrun{
#' clb_relation("4CGXP", dataset = "3LR")
#' }
clb_relation <- function(id, dataset = "3LXR", .raw = FALSE) {
  clb_taxon_records(id, dataset, "relation", .raw = .raw)
}

#' Metrics for a taxon
#'
#' Returns subtree metrics for a taxon: tree depth, child and species counts,
#' and a by-rank breakdown of descendants.
#'
#' @param id Taxon id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A one-row [tibble][tibble::tibble] of metrics. Map fields such as
#'   `taxaByRankCount` are returned as list-columns.
#' @seealso [clb_dataset_metrics()], [clb_children()]
#' @export
#' @examples
#' \dontrun{
#' clb_usage_metrics("4CGXP", dataset = "3LR")
#' }
clb_usage_metrics <- function(id, dataset = "3LXR", .raw = FALSE) {
  resp <- clb_get("dataset", as.character(dataset), "taxon", as.character(id), "metrics")
  if (isTRUE(.raw)) return(resp)
  clb_records_to_tibble(list(resp))
}
