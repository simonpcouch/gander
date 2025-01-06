#' Options used by the gander package
#'
#' @description
#' The gander package makes use of two notable user-facing options:
#'
#' * `.gander_fn` and `.gander_args` determine the underlying LLM powering the
#'   assistant.
#'
#' @name gander_options
NULL

initialize_assistant <- function(context, input) {
  chat <- new_chat()

  system_prompt <- construct_system_prompt(context, input)

  chat$set_system_prompt(system_prompt)

  chat
}

new_chat <- function(
    fn = getOption(".gander_fn", default = "chat_claude"),
    ...,
    .ns = "ellmer"
) {
  args <- list(...)
  default_args <- getOption(".gander_args", default = list())
  args <- modifyList(default_args, args)

  rlang::eval_bare(rlang::call2(fn, !!!args, .ns = .ns))
}

construct_system_prompt <- function(context, input) {
  ext <- file_extension(context$path)

  if (ext %in% c("r", "py")) {
    lang_str <- ext_to_language(ext)
    res <-
      glue::glue(
        "You are a helpful but terse {lang_str} data scientist. ",
        "Respond only with valid {lang_str} code: no exposition, no backticks. "
      )
  } else {
    res <-
      paste0(
        "You are a helpful but terse data scientist. ",
        "When asked for code, provide only the requested code, no exposition nor ",
        "backticks, unless explicitly asked. "
      )
  }

  res <- c(
    res,
    "Always provide a minimal solution and refrain from unnecessary additions. ",
    paste0(
      "Use tidyverse style and, when relevant, tidyverse packages. For example, ",
      "when asked to plot something, use ggplot2, or when asked to transform ",
      "data, using dplyr and/or tidyr unless explicitly instructed otherwise. "
    )
  )

  paste(res, collapse = "")
}

construct_turn <- function(input, context) {
  code_context <- paste0(
    c(paste0("##", context$path, ":"), "", context$contents),
    collapse = "\n"
  )
  selection <- rstudioapi::primary_selection(context)[["text"]]

  res <- input$text

  if (identical(input$interface, "Replace")) {
    res <- c(
      "Update the following: ",
      "",
      rstudioapi::primary_selection(context)[["text"]],
      "",
      "Per the following instructions: ",
      "",
      res,
      ""
    )
  } else {
    if (!identical(selection, "")) {
      res <- c(
        paste0(res, ":", collapse = ""),
        "",
        selection
      )
    }
  }

  res <- c(res, describe_relevant_variables(selection, env = global_env()))

  if (identical(code_context, character(0)) ||
      identical(code_context, selection)) {
    return(paste0(res, collapse = "\n"))
  }

  paste0(
    c(
      res,
      "",
      "Here's some additional context from source files: ",
      "",
      code_context
    ),
    collapse = "\n"
  )
}

file_extension <- function(file_path) {
  check_character(file_path)

  ext <- strsplit(basename(file_path), "\\.")[[1]]

  if (length(ext) <= 1) {
    return("")
  }

  tolower(ext[length(ext)])
}
