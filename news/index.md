# Changelog

## rcol 0.1.0

CRAN release: 2021-02-05

- Initial release.
- `col_*()` shortcut functions
  ([`col_match()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md),
  [`col_usage()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md),
  [`col_tree()`](https://catalogueoflife.github.io/rcol/reference/col_shortcuts.md),
  …) that always target the latest extended COL release without a
  `dataset` argument. The release is resolved once to its integer key
  and pinned for the session via
  [`col_key()`](https://catalogueoflife.github.io/rcol/reference/col_key.md);
  [`col_refresh()`](https://catalogueoflife.github.io/rcol/reference/col_refresh.md)
  re-pins to a newer release.
- Name matching against any dataset or COL release:
  [`clb_match()`](https://catalogueoflife.github.io/rcol/reference/clb_match.md),
  [`clb_match_verbose()`](https://catalogueoflife.github.io/rcol/reference/clb_match_verbose.md),
  [`clb_match_checklist()`](https://catalogueoflife.github.io/rcol/reference/clb_match_checklist.md).
- COL release discovery:
  [`clb_col_release()`](https://catalogueoflife.github.io/rcol/reference/clb_col_release.md),
  [`clb_col_releases()`](https://catalogueoflife.github.io/rcol/reference/clb_col_releases.md)
  covering the monthly base (`3LR`), monthly extended (`3LXR`) and
  annual (`COL<YY>`) releases.
- Parsers:
  [`clb_parsers()`](https://catalogueoflife.github.io/rcol/reference/clb_parsers.md),
  [`clb_parse_name()`](https://catalogueoflife.github.io/rcol/reference/clb_parse_name.md),
  [`clb_parse()`](https://catalogueoflife.github.io/rcol/reference/clb_parse.md).
- Datasets:
  [`clb_dataset_search()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset_search.md),
  [`clb_dataset()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset.md),
  [`clb_dataset_metrics()`](https://catalogueoflife.github.io/rcol/reference/clb_dataset_metrics.md).
- Name usages and taxa:
  [`clb_usage()`](https://catalogueoflife.github.io/rcol/reference/clb_usage.md),
  [`clb_usage_search()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_search.md)
  /
  [`clb_search()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_search.md),
  [`clb_suggest()`](https://catalogueoflife.github.io/rcol/reference/clb_suggest.md),
  [`clb_classification()`](https://catalogueoflife.github.io/rcol/reference/clb_classification.md),
  [`clb_synonyms()`](https://catalogueoflife.github.io/rcol/reference/clb_synonyms.md),
  [`clb_vernacular()`](https://catalogueoflife.github.io/rcol/reference/clb_vernacular.md),
  [`clb_usage_metrics()`](https://catalogueoflife.github.io/rcol/reference/clb_usage_metrics.md).
- Tree navigation:
  [`clb_tree()`](https://catalogueoflife.github.io/rcol/reference/clb_tree.md),
  [`clb_children()`](https://catalogueoflife.github.io/rcol/reference/clb_children.md).
