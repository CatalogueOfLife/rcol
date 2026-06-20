# Package index

## Catalogue of Life shortcuts

Convenience functions that always target the latest extended COL
release, pinned to a fixed key for the session.

- [`col_match()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_match_verbose()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_match_checklist()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_dataset()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_dataset_metrics()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_usage()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_usage_search()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_search()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_suggest()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_classification()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_synonyms()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_vernacular()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_usage_metrics()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_tree()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  [`col_children()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md)
  : Catalogue of Life shortcuts
- [`col_key()`](https://catalogueoflife.github.io/rcol/reference/col_key.md)
  : The pinned Catalogue of Life release key
- [`col_refresh()`](https://catalogueoflife.github.io/rcol/reference/col_refresh.md)
  : Re-pin the Catalogue of Life release

## Name matching

Match scientific names against any dataset or COL release.

- [`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md)
  : Match a scientific name against a ChecklistBank dataset
- [`clb_match_verbose()`](https://catalogueoflife.github.io/rcol/reference/clb_match_verbose.md)
  : Match a name and return all candidate usages
- [`clb_match_checklist()`](https://catalogueoflife.github.io/rcol/reference/clb_match_checklist.md)
  : Match a checklist of names in bulk

## Catalogue of Life releases

- [`clb_col_release()`](https://catalogueoflife.github.io/rcol/reference/clb_col_release.md)
  : Resolve a Catalogue of Life release
- [`clb_col_releases()`](https://catalogueoflife.github.io/rcol/reference/clb_col_releases.md)
  : List all Catalogue of Life releases

## Parsers

- [`clb_parsers()`](https://catalogueoflife.github.io/rcol/reference/clb_parsers.md)
  : List the available ChecklistBank parsers
- [`clb_parse_name()`](https://catalogueoflife.github.io/rcol/reference/clb_parse_name.md)
  : Parse scientific names
- [`clb_parse()`](https://catalogueoflife.github.io/rcol/reference/clb_parse.md)
  : Parse values with a ChecklistBank value parser

## Datasets

- [`clb_dataset_search()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset_search.md)
  : Search datasets in ChecklistBank
- [`clb_dataset()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset.md)
  : Get dataset metadata
- [`clb_dataset_metrics()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset_metrics.md)
  : Dataset metrics

## Name usages & taxa

- [`clb_usage()`](https://catalogueoflife.github.io/rcol/reference/clb_usage.md)
  : Get a name usage (taxon or synonym) by id
- [`clb_usage_search()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_search.md)
  [`clb_search()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_search.md)
  : Full-text search of name usages
- [`clb_suggest()`](https://catalogueoflife.github.io/rcol/reference/clb_suggest.md)
  : Autocomplete suggestions for name usages
- [`clb_classification()`](https://catalogueoflife.github.io/rcol/reference/clb_classification.md)
  : Taxonomic classification (lineage) of a taxon
- [`clb_synonyms()`](https://catalogueoflife.github.io/rcol/reference/clb_synonyms.md)
  : Synonyms of a taxon
- [`clb_vernacular()`](https://catalogueoflife.github.io/rcol/reference/clb_vernacular.md)
  : Vernacular (common) names
- [`clb_usage_metrics()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_metrics.md)
  : Metrics for a taxon

## Tree navigation

- [`clb_tree()`](https://catalogueoflife.github.io/rcol/reference/clb_tree.md)
  : Navigate the taxonomic tree
- [`clb_children()`](https://catalogueoflife.github.io/rcol/reference/clb_children.md)
  : Direct children of a taxon

## Configuration

- [`clb_base_url()`](https://catalogueoflife.github.io/rcol/reference/clb_base_url.md)
  : The ChecklistBank API base URL
