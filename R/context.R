# code inspection --------------------------------------------------------------
# context is rstudioapi::getActiveDocumentContext() or friends
fetch_code_context <- function(context) {
  contents <- context$contents
  selection <- context$selection

  before <- contents[seq_len(selection[[1]]$range$start[1] - 1)]
  after <- contents[seq(selection[[1]]$range$end[1] + 1, length(contents))]
  list(before = backtick_possibly(before), after = backtick_possibly(after))
}

backtick_possibly <- function(x) {
  if (length(x) == 0) {
    return(character(0))
  } else {
    c("```", x, "```")
  }
}

# environment inspection -------------------------------------------------------
fetch_env_context <- function(selection, input, env) {
  obj_names <- names(env)

  # is the object name present in the selection or mentioned in the input?
  mentioned <- obj_names[
    obj_names %in% selected_variables(selection) |
    unname(vapply(obj_names, grepl, logical(1), x = input))
  ]

  res <- describe_variables(mentioned, env)

  if (identical(res, character(0))) {
    return(res)
  }

  c("```", res, "```")
}

describe_variables <- function(variables, env) {
  if (length(variables) == 0) {
    return(character(0))
  }

  res <- character(0)
  for (variable in variables) {
    if (!env_has(env, variable)) next
    res <- c(res, describe_variable(env_get(env, variable), variable), "")
  }

  res
}

describe_variable <- function(x, x_name) {
  # to limit the number of tokens taken up by data frames, only print the
  # first few rows and columns of data frames
  if (inherits(x, "data.frame")) {
    n_row <- min(5, nrow(x))
    n_col <- min(20, ncol(x))
    x <- x[seq_len(n_row), seq_len(n_col), drop = FALSE]
    x_name <- c(
      cli::format_inline("# Just the first {n_row} row{?s} and {n_col} column{?s}:"),
      x_name
    )
  }

  # todo: large lists may still take up quite a few tokens here. should we just
  # subset this output to the first n entries?
  c(
    x_name,
    paste0("#> ", gsub("\t.*$", "", capture.output(str(x))))
  )
}

selected_variables <- function(selection) {
  language <- treesitter.r::language()
  parser <- treesitter::parser(language)
  tree <- treesitter::parser_parse(parser, selection)
  root <- treesitter::tree_root_node(tree)

  if (!is_syntactically_valid(root)) {
    # just split up by spaces and return---it's okay if this function's output
    # is a superset since its results will be filtered by the names of objects
    # in an environment
    return(strsplit(selection, " ", fixed = TRUE)[[1]])
  }

  query_source <- '
    (identifier) @id
    (call function: (identifier) @func)
  '

  query <- treesitter::query(language, query_source)
  captures <- treesitter::query_captures(query, root)
  identifiers <- unique(vapply(captures$node, treesitter::node_text, character(1)))

  unique(identifiers)
}

is_syntactically_valid <- function(root) {
  !treesitter::node_has_error(root) &&
  !treesitter::node_is_error(root) &&
  !treesitter::node_is_missing(root)
}
