# rcol (development version)

* `clb_usage()`, `clb_usage_search()`, `clb_usage_info()` and `clb_synonyms()`
  now return all name usage fields instead of a small subset: `origin`, the
  dataset, sector and verbatim keys, `identifier`, `reference_ids`, `link`,
  `remarks`, the scrutinizer and temporal range of taxa, and `accepted_id` /
  `accepted_name` for synonyms. `accepted_id` falls back to `parent_id` when
  the API omits the accepted usage, as for `clb_synonyms()`. `clb_usage_search()` also returns
  `sector_dataset_key`, `sector_publisher_key`, `secondary_source_keys` and
  `secondary_source_groups`.

# rcol 1.0.0

* First release of the ChecklistBank-based client. It is unrelated to the
  rOpenSci `rcol` package (versions 0.1.0 to 0.2.0, archived on CRAN in 2022),
  which had a different API.
* `col_*()` shortcut functions (`col_match()`, `col_usage()`, `col_tree()`, ...)
  that always target the latest extended COL release without a `dataset`
  argument. The release is resolved once to its integer key and pinned for the
  session via `col_key()`; `col_refresh()` re-pins to a newer release.
* Name matching against any dataset or COL release: `clb_match()`,
  `clb_match_verbose()`, `clb_match_checklist()`.
* COL release discovery: `clb_col_release()`, `clb_col_releases()` covering the
  monthly base (`3LR`), monthly extended (`3LXR`) and annual (`COL<YY>`)
  releases.
* Parsers: `clb_parsers()`, `clb_parse_name()`, `clb_parse()`.
* Datasets: `clb_dataset_search()`, `clb_dataset()`, `clb_dataset_metrics()`.
* Name usages and taxa: `clb_usage()`, `clb_usage_info()`,
  `clb_usage_search()` / `clb_search()`, `clb_suggest()`,
  `clb_classification()`, `clb_synonyms()`, `clb_vernacular()`,
  `clb_distribution()`, `clb_interaction()`, `clb_media()`, `clb_property()`,
  `clb_relation()`, `clb_usage_metrics()`.
* `clb_usage_info()` / `col_usage_info()` return the full usage information
  document (usage, classification, synonymy, vernacular names, distributions,
  references, ...) in a single request.
* Tree navigation: `clb_tree()`, `clb_children()`.
