fetch_code_context <- function(input_selection, context) {
  switch(
    input_selection,
    None = character(0),
    Selection = context_from_selection(context),
    File = context_from_file(context),
    `File & Neighbors` = context_from_file_and_neighbors(context)
  )
}

context_from_selection <- function(context) {
  paste0(context$selection[[1]][["text"]], collapse = "\n")
}

context_from_file <- function(context) {
  paste0(c(paste0("##", context$path, ":"), "", context$contents), collapse = "\n")
}

context_from_file_and_neighbors <- function(context) {
  # TODO: implement this like ensure
  paste0(context$contents, collapse = "\n")
}
