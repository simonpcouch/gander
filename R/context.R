# code inspection --------------------------------------------------------------
# context is rstudioapi::getActiveDocumentContext() or friends
fetch_code_context <- function(context) {
  contents <- context$contents
  selection <- context$selection

  end_before <- selection[[1]]$range$start[1] - 1
  start_after <- min(selection[[1]]$range$end[1] + 1, length(contents))

  before <- contents[seq_len(end_before)]
  after <- contents[seq(start_after, length(contents))]
  list(
    before = backtick_possibly(before),
    after = backtick_possibly(after),
    selection = backtick_possibly(
      contents[seq(selection[[1]]$range$start[1], selection[[1]]$range$end[1])]
    )
  )
}

backtick_possibly <- function(x) {
  if (length(x) == 0 || identical(x, "")) {
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
  # summary or the first few rows for the given number of columns of data frames
  if (inherits(x, "data.frame")) {
    dims <- fetch_gander_dims()

    if (is.character(dims) && identical(dims[1], "summary")) {
      n_col <- min(as.integer(dims[2]), ncol(x))
      x <- x[, seq_len(n_col), drop = FALSE]

      summaries <- character(0)
      for(col in names(x)) {
        if(is.numeric(x[[col]])) {
          col_summ <- summary(x[[col]])
          summ_values <- sprintf("%.4f", unname(col_summ))
          summ_str <- paste(summ_values, collapse = "  ")
        } else {
          # For categorical: count unique values
          col_summ <- table(x[[col]])
          # Filter for values appearing 5 or more times
          frequent_vals <- col_summ[col_summ >= 5]
          n_unique <- length(unique(x[[col]]))
          n_shown <- length(frequent_vals)

          if(n_shown == 0) {
            # If no values appear 5+ times
            summ_str <- sprintf("(%d unique values, all appear < 5 times)", n_unique)
          } else if(n_shown <= 10) {
            # Show all frequent values and note remaining
            n_remaining <- n_unique - n_shown
            summ_str <- paste0(
              paste(paste(names(frequent_vals), frequent_vals, sep = ": "), collapse = "  "),
              if(n_remaining > 0) sprintf("  (...%d values appear < 5 times)", n_remaining) else ""
            )
          } else {
            # If more than 10 frequent categories, show top 5
            frequent_vals <- sort(frequent_vals, decreasing = TRUE)[1:5]
            n_remaining <- n_unique - 5
            summ_str <- paste0(
              paste(paste(names(frequent_vals), frequent_vals, sep = ": "), collapse = "  "),
              sprintf("  (...%d more values, some appear < 5 times)", n_remaining)
            )
          }
        }
        summaries <- c(summaries,
                       paste0("#> ", col, ": ", summ_str))
      }

      return(c(
        cli::format_inline("# Summary of first {n_col} column{?s}:"),
        x_name,
        summaries
      ))
    } else {

      n_row <- min(dims[1], nrow(x))
      n_col <- min(dims[2], ncol(x))
      x <- x[seq_len(n_row), seq_len(n_col), drop = FALSE]
      x_name <- c(
        cli::format_inline("# Just the first {n_row} row{?s} and {n_col} column{?s}:"),
        x_name
      )
    }
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
