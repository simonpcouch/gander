#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import rlang
## usethis namespace: end
NULL

utils::globalVariables(
  c(
    "capture.output",
    "file.edit",
    "help",
    "modifyList",
    ".ps.ui.executeCommand",
    "str"
  )
)

# address "not imported from" R CMD check error
#' @importFrom ellmer content_image_file
#' @importFrom glue glue
NULL
