# Tree navigation ------------------------------------------------------------

#' Navigate the taxonomic tree
#'
#' Without `id`, returns the root taxa of the dataset's tree. With `id`,
#' returns the path (lineage) from the root down to that taxon. Use
#' [clb_children()] to descend one level.
#'
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param id Optional taxon id. When omitted the tree roots are returned.
#' @param extinct Logical; include extinct taxa. Defaults to `TRUE`.
#' @param ... Further query parameters (e.g. `insertPlaceholder`).
#' @param limit Page size when listing roots.
#' @param max Maximum number of roots to return.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of tree nodes with columns such as `id`,
#'   `name`, `authorship`, `rank`, `status`, `childCount` and `count`.
#' @seealso [clb_children()], [clb_classification()]
#' @export
#' @examples
#' \dontrun{
#' clb_tree(dataset = "3LR")            # kingdoms / roots
#' clb_tree(dataset = "3LR", id = "4CGXP")  # lineage of a taxon
#' }
clb_tree <- function(dataset = "3LXR", id = NULL, extinct = TRUE, ...,
                     limit = 100L, max = limit, .raw = FALSE) {
  if (!is.null(id)) {
    resp <- clb_get(
      "dataset", as.character(dataset), "tree", as.character(id),
      query = clb_query(extinct = extinct, ...)
    )
    if (isTRUE(.raw)) return(resp)
    return(clb_records_to_tibble(resp))
  }
  paged <- clb_get_paged(
    "dataset", as.character(dataset), "tree",
    query = clb_query(extinct = extinct, ...),
    limit = limit, max = max
  )
  if (isTRUE(.raw)) return(paged$result)
  clb_records_to_tibble(paged$result)
}

#' Direct children of a taxon
#'
#' Lists the immediate child taxa of a node in the taxonomic tree.
#'
#' @param id Taxon id within the dataset.
#' @param dataset Dataset key or alias. Defaults to `"3LXR"`.
#' @param extinct Logical; include extinct taxa. Defaults to `TRUE`.
#' @param ... Further query parameters (e.g. `insertPlaceholder`).
#' @param limit Page size per request.
#' @param max Maximum number of children to return. Use `Inf` to fetch all.
#' @param .raw Return the raw parsed JSON instead of a tibble?
#'
#' @return A [tibble][tibble::tibble] of child tree nodes.
#' @seealso [clb_tree()], [clb_classification()]
#' @export
#' @examples
#' \dontrun{
#' roots <- clb_tree(dataset = "3LR")
#' clb_children(roots$id[1], dataset = "3LR")
#' }
clb_children <- function(id, dataset = "3LXR", extinct = TRUE, ...,
                         limit = 100L, max = limit, .raw = FALSE) {
  paged <- clb_get_paged(
    "dataset", as.character(dataset), "tree", as.character(id), "children",
    query = clb_query(extinct = extinct, ...),
    limit = limit, max = max
  )
  if (isTRUE(.raw)) return(paged$result)
  clb_records_to_tibble(paged$result)
}
