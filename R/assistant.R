#' Options used by the gander package
#'
#' @description
#' The gander package makes use of a few notable user-facing options.
#'
#' @section Choosing models:
#'
#' gander uses the `gander.chat` option to configure which model powers the
#' addin. `gander.chat` is an ellmer Chat object.
#' For example, to use Anthropic's Claude Sonnet 4.6, you might write
#'
#' ```
#' options(gander.chat = ellmer::chat_claude(model = "claude-sonnet-4-6"))
#' ```
#'
#' Paste that code in your `.Rprofile` via `usethis::edit_r_profile()` to
#' always use the same model every time you start an R session.
#'
#' The legacy option `.gander_chat` is also supported. The gander package used
#' to use options `.gander_fn` and `.gander_args`, but those are deprecated in
#' favor of `gander.chat`.
#'
#' @section Style/taste:
#'
#' By default, gander responses use the following style
#' conventions: "`r default_gander_style()`" Set the `gander.style` option to
#' some other string to tailor responses to your own taste, e.g.:
#'
#' ```r
#' options(gander.style = "Use base R.")
#' ```
#'
#' Paste that code in your
#' `.Rprofile` via `usethis::edit_r_profile()` to always use the same style (or
#' even always begin with some base set of knowledge about frameworks you
#' work with often) every time you start an R session. The legacy option
#' `.gander_style` is also supported.
#'
#' @section Data context:
#'
#' By default, gander will show the first 5 rows and 100 columns of every
#' relevant data frame, allowing for models to pick up on the names, types, and
#' distributions of the variables it may work with while also keeping the number
#' of tokens submitted per chat to a minimum. The option `gander.dims` allows
#' you to adjust how many rows and columns to supply to gander addin.
#'
#' * For richer context but increasing token usage, increase the number of rows
#'   and columns. For example, to supply the first 50 rows and all columns of
#'   datasets supplied to the model, you could use
#'   `options(gander.dims = c(50, Inf))`.
#' * To decrease token usage, decrease the number of rows and columns, e.g.
#'   `options(gander.dims = c(0, 10))` to just show the names and types of the
#'   first 10 columns. One could make the argument that setting the number of rows
#'   to 0 is privacy-preserving, but do note that the model may pick up on the
#'   values of specific cells based on code context alone. To learn more, see
#'   \url{https://posit.co/blog/trust-llm-tools/}.
#'
#' Set that option in your `~/.Rprofile` to always use that setting. The legacy
#' option `.gander_dims` is also supported.
#'
#' @examples
#' # Running the following will adjust R options, so don't run by default:
#' \dontrun{
#' # Describe the first 100 rows and every column in relevant data
#' # frames rather than the first 5 rows and 100 columns (this can
#' # increase token usage greatly):
#' options(gander.dims = c(100, Inf))
#'
#' # Only describe relevant data frame columns and their types, but don't
#' # provide any rows:
#' options(gander.dims = c(0, Inf))
#'
#' # Override default tidyverse style to tell the model to prefer another style:
#' options(gander.style = "Use base R.")
#'
#' # Configure gander to use its recommended model, Anthropic's Claude Sonnet
#' # 4.6. Set this option in your `~/.Rprofile` to always use this setting.
#' # Note that this requires an `ANTHROPIC_API_KEY` envvar:
#' options(gander.chat = ellmer::chat_claude(model = "claude-sonnet-4-6"))
#' }
#'
#' @name gander_options
#' @aliases gander.chat
#' @aliases .gander_chat
#' @aliases .gander_fn
#' @aliases .gander_args
#' @aliases gander.dims
#' @aliases .gander_dims
#' @aliases gander.style
#' @aliases .gander_style
NULL

get_gander_chat <- function() {
  getOption("gander.chat", getOption(".gander_chat"))
}

get_gander_dims <- function() {
  getOption("gander.dims", getOption(".gander_dims"))
}

initialize_assistant <- function(context, input, chat) {
  selection <- rstudioapi::primary_selection(context)[["text"]]
  has_selection <- !identical(selection, "")
  system_prompt <- construct_system_prompt(context, input, has_selection)

  chat$set_system_prompt(system_prompt)

  chat
}

new_chat <- function(
  .gander_chat = get_gander_chat()
) {
  # first, check that the ellmer chat itself will initialize successfully
  .gander_fn <- getOption(".gander_fn")
  .gander_args <- getOption(".gander_args")
  if (!is.null(.gander_fn) && is.null(.gander_chat)) {
    cli::cli_inform(
      c(
        "!" = "{.pkg gander} now uses the option {cli::col_blue('gander.chat')} instead
       of {cli::col_blue('.gander_fn')} and {cli::col_blue('.gander_args')}.",
        "i" = "Set
      {.code options(gander.chat = {deparse(rlang::call2(.gander_fn, !!!.gander_args))})}
      instead."
      ),
      call = NULL
    )
    return(NULL)
  }

  res <- fetch_gander_chat(.gander_chat)

  # then, check that the model will be able to successfully assemble a prompt
  # based on user-provider options
  .gander_dims <- fetch_gander_dims()
  if (is.null(.gander_dims)) {
    return(NULL)
  }

  # ...before returning:
  res
}

# this function fails with messages and a NULL return value rather than errors
# so that, when called from inside the addin, there's no dialog box raised by RStudio
fetch_gander_chat <- function(x) {
  # adapted from check_function, but errors a bit more informatively
  if (is.null(x)) {
    cli::cli_inform(
      c(
        "!" = "gander requires configuring an ellmer Chat with the
        {cli::col_blue('gander.chat')} option.",
        "i" = "Set e.g.
        {.code {cli::col_green('options(gander.chat = ellmer::chat_claude(model = \"claude-sonnet-4-6\"))')}}
        in your {.file ~/.Rprofile} and restart R.",
        "i" = "See \"Choosing a model\" in
        {.code vignette(\"gander\", package = \"gander\")} to learn more."
      ),
      call = NULL
    )
    return(NULL)
  }

  if (!inherits(x, "Chat")) {
    cli::cli_inform(
      c(
        "!" = "The option {cli::col_blue('gander.chat')} must be an ellmer
        Chat object, not {.obj_type_friendly {x}}.",
        "i" = "See \"Choosing a model\" in
        {.code vignette(\"gander\", package = \"gander\")} to learn more."
      ),
      call = NULL
    )
    return(NULL)
  }

  x$clone()
}

fetch_gander_dims <- function(silent) {
  .gander_dims <- get_gander_dims()

  if (is.null(.gander_dims)) {
    return(default_gander_dims)
  }

  if (length(.gander_dims) != 2L || !is_integerish(.gander_dims)) {
    cli::cli_inform(
      c(
        "!" = "The option {cli::col_blue('gander.dims')} must be a 2-length
               integer vector, e.g. {.code c(5L, 100L)}, not
               {.obj_type_friendly { .gander_dims}}.",
        "i" = "See {.topic gander.dims} to learn more."
      ),
      call = NULL
    )
    return(NULL)
  }

  return(.gander_dims)
}

construct_system_prompt <- function(context, input, has_selection = FALSE) {
  ext <- file_extension(context$path)

  res <- "You are a helpful but terse R data scientist. "
  if (identical(ext, "r")) {
    res <- c(
      res,
      "Respond only with valid R code: no exposition, no backticks. "
    )
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

  if (has_selection) {
    res <- c(
      res,
      paste0(
        "\n\nYour task is to apply the user's request to their selected text. ",
        "Return only the replacement text for the selection--",
        "no surrounding context, no explanation, no backticks."
      )
    )
  }

  paste(res, collapse = "")
}

construct_turn <- function(
  user_prompt,
  context = rstudioapi::getActiveDocumentContext()
) {
  selection <- rstudioapi::primary_selection(context)[["text"]]

  code_context <- fetch_code_context(context)
  env_context <- fetch_env_context(selection, user_prompt, env = global_env())

  construct_turn_impl(
    user_prompt = user_prompt,
    code_context = code_context,
    env_context = env_context
  )
}

# all inputs are just character vectors
construct_turn_impl <- function(user_prompt, code_context, env_context) {
  res <- c()

  file_contents <- code_context[["file_contents"]]
  selection <- code_context[["selection"]]
  selection_raw <- code_context[["selection_raw"]] %||% ""

  if (length(file_contents) > 0) {
    res <- c("The user is currently working in this file:", "")
    res <- c(res, file_contents)
  }

  user_prompt <- sub("\\.$", "", user_prompt)

  res <- c(res, "", "The user made the following request:", "")
  res <- c(res, paste0("> ", user_prompt))

  if (length(selection) > 0) {
    res <- c(
      res, "",
      "The user has made the following selection that they'd like to apply the request to:",
      ""
    )
    res <- c(res, selection)
  }

  if (!identical(env_context, character(0))) {
    res <- c(
      res,
      "",
      "Here's some information about the objects in the user's R environment:",
      ""
    )
    res <- c(res, env_context)
  }

  if (nzchar(selection_raw)) {
    if (grepl("`", selection_raw, fixed = TRUE)) {
      res <- c(
        res, "",
        paste0(
          "The five-backtick fences above are delimiters used to frame the ",
          "content in this prompt. Any backticks inside the fenced blocks are ",
          "part of the actual file contents. Your response should include ",
          "backticks exactly as they appear in the selection but should not ",
          "include the five-backtick fences themselves."
        )
      )
    } else {
      res <- c(res, "", "Do not include backticks or code fences in your response.")
    }
  }

  paste0(res, collapse = "\n")
}
