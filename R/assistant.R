#' Options used by the gander package
#'
#' @description
#' The gander package makes use of a few notable user-facing options.
#'
#' @section Choosing models:
#'
#' gander uses the `.gander_chat` option to configure which model powers the
#' addin. `.gander_chat` is a function that returns an ellmer Chat object.
#' For example, to use OpenAI's GPT-4o-mini, you might write
#'
#' ```
#' options(.gander_chat = function() chat_claude())
#' ```
#'
#' Paste that code in your `.Rprofile` via `usethis::edit_r_profile()` to
#' always use the same model every time you start an R session.
#'
#' The gander package used to use options `.gander_fn` and `.gander_args`,
#' but those are deprecated in favor of `.gander_chat`.
#'
#' @section Style/taste:
#'
#' By default, gander responses use the following style
#' conventions: "`r default_gander_style()`" Set the `.gander_style` option to
#' some other string to tailor responses to your own taste, e.g.:
#'
#' ```r
#' options(.gander_style = "Use base R.")
#' ```
#'
#' Paste that code in your
#' `.Rprofile` via `usethis::edit_r_profile()` to always use the same style (or
#' even always begin with some base set of knowledge about frameworks you
#' work with often) every time you start an R session.
#'
#' @name gander_options
#' @aliases .gander_fn
#' @aliases .gander_args
#' @aliases .gander_chat
#' @aliases .gander_style
NULL

initialize_assistant <- function(context, input) {
  chat <- new_chat()

  system_prompt <- construct_system_prompt(context, input)

  chat$set_system_prompt(system_prompt)

  chat
}

new_chat <- function(
    .gander_chat = getOption(".gander_chat")
) {
  # first, check for old options
  .gander_fn <- getOption(".gander_fn")
  .gander_args <- getOption(".gander_args")
  if (!is.null(.gander_fn) && is.null(.gander_chat)) {
    new_option <- translate_gander_option(.gander_fn, .gander_args)
    cli::cli_abort(c(
      "{.pkg gander} now uses the option {cli::col_blue('.gander_chat')} instead
       of {cli::col_blue('.gander_fn')} and {cli::col_blue('.gander_args')}.",
      "i" = "Set {.code options(.gander_chat = {new_option})} instead."
    ), call = NULL)
  }

  fetch_gander_chat(.gander_chat)
}

translate_gander_option <- function(.gander_fn, .gander_args) {
  # two notes on why this is funky:
  # * escapes brackets with doubling
  # * substitutes in a call, which is enumerated unless deparsed
  cli::format_inline(
    "function() {{{deparse(rlang::call2(.gander_fn, !!!.gander_args))}}"
  )
}

fetch_gander_chat <- function(.gander_chat) {
  check_gander_chat(.gander_chat, call = NULL)
  .gander_chat()
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
    get_gander_style()
  )

  paste(res, collapse = "")
}

construct_turn <- function(input, context) {
  selection <- rstudioapi::primary_selection(context)[["text"]]

  code_context <- fetch_code_context(context)
  env_context <- fetch_env_context(selection, input$text, env = global_env())

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
    res <- c(res, paste0(gsub("\\.$", "", input$text), "."))
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
