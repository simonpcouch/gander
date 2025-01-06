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

  res <- "You are a helpful but terse R data scientist. "
  if (identical(ext, "r")) {
    res <- c(res, "Respond only with valid R code: no exposition, no backticks. ")
  } else {
    res <- c(
      res,
      paste0(
        "When asked for code, provide only the requested code, no exposition nor ",
        "backticks, unless explicitly asked. "
      )
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
  selection <- rstudioapi::primary_selection(context)[["text"]]

  code_context <- fetch_code_context(context)
  env_context <- fetch_env_context(selection, env = global_env())

  construct_turn_impl(
    input = input,
    selection = selection,
    code_context = code_context,
    env_context = env_context,
    ext = file_extension(context$path)
  )
}

# all inputs are just character vectors
construct_turn_impl <- function(input, selection, code_context, env_context, ext) {
  res <- paste0("Up to this point, the contents of my ", ext, " file reads: ")
  res <- c(res, "", code_context[["before"]], "")

  if (!identical(selection, "")) {
    res <- c(res, paste0("Now, ", input$text, ": "))
    res <- c(res, "", selection, "")
  } else {
    res <- c(res, paste0(gsub("\\.$", "", input), "."))
  }

  if (!identical(code_context[["after"]], character(0))) {
    res <- c(res, "", "For context, the rest of the file reads: ", "")
    res <- c(res, code_context[["after"]])
  }

  if (!identical(env_context, character(0))) {
    res <- c(res, "", "Here's some information about the objects in my R environment: ")
    res <- c(res, "", env_context, "")
  }

  paste0(res, collapse = "\n")
}
