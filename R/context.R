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
fetch_env_context <- function(selection, env) {
  if (identical(selection, "")) {
    res <- describe_data_frames(env = env)
  } else {
    res <- describe_selected_variables(selection = selection, env = env)
  }

  if (identical(res, character(0))) {
    return(res)
  }

  c("```", res, "```")
}

describe_data_frames <- function(env) {
  env_list <- as.list(env)
  env_dfs <- names(env_list[purrr::map_lgl(env_list, is.data.frame)])

  if (length(env_dfs) == 0) {
    return(character(0))
  }

  res <- character(0)
  for (i in seq_along(env_dfs)) {
    res <- c(
      res,
      describe_variable(
        env_get(env, env_dfs[[i]]),
        env_dfs[[i]]
      ),
      ""
    )
  }

  res
}

describe_selected_variables <- function(selection, env) {
  variables_to_describe <- selected_variable_names_in_env(selection = selection, env = env)

  if (length(variables_to_describe) == 0) {
    return(character(0))
  }

  res <- character(0)
  for (variable in variables_to_describe) {
    res <- c(res, describe_variable(env_get(env, variable), variable), "")
  }

  res
}

selected_variable_names_in_env <- function(selection, env) {
  selected_variable_names <- selected_variable_names(selection = selection)

  selected_variables_in_env <- env_has(env, selected_variable_names)

  selected_variable_names[selected_variables_in_env]
}

describe_variable <- function(x, x_name) {
  c(
    x_name,
    paste0("#> ", gsub("\t", " ", capture.output(str(x))))
  )
}

selected_variable_names <- function(selection) {
  language <- treesitter.r::language()
  parser <- treesitter::parser(language)
  tree <- treesitter::parser_parse(parser, selection)
  root_node <- treesitter::tree_root_node(tree)
  query_source <- "(identifier) @id"
  query <- treesitter::query(language, query_source)
  captures <- treesitter::query_captures(query, root_node)
  variable_names <- vapply(captures$node, treesitter::node_text, character(1))
  unique(variable_names)
}
