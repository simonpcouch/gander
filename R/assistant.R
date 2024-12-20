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

  res <- switch(
    ext,
    r = "You are a helpful but terse R data scientist.",
    py = "You are a helpful but terse Python data scientist.",
    character(0)
  )

  res <- c(
    res,
    paste0(
      "When asked for code, provide only the requested code, no exposition nor ",
      "backticks, unless explicitly asked. Always provide a minimal solution and",
      "refrain from unnecessary additions."
    ),
    paste0(
      "Use tidyverse style and, when relevant, tidyverse packages. For example, ",
      "when asked to plot something, use ggplot2, or when asked to transform ",
      "data, using dplyr and/or tidyr unless explicitly instructed otherwise."
    )
  )

  paste(res, collapse = "")
}

construct_turn <- function(input, context) {
  context_text <- fetch_context(input$context, context)

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
    selection <- rstudioapi::primary_selection(context)[["text"]]
    if (!identical(selection, "")) {
      res <- c(
        paste0(res, ":", collapse = ""),
        "",
        selection
      )
    }
  }

  if (identical(context_text, character(0))) {
    return(paste0(res, collapse = "\n"))
  }

  paste0(
    c(
      res,
      "",
      "Here's some additional context: ",
      "",
      context_text
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
