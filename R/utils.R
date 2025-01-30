# miscellaneous ----------------------------------------------------------------
interactive <- NULL

is_positron <- function() {
  Sys.getenv("POSITRON") == "1"
}

global_env <- function() {
  .GlobalEnv
}

file_extension <- function(file_path) {
  check_character(file_path)

  ext <- strsplit(basename(file_path), "\\.")[[1]]

  if (length(ext) <= 1) {
    return("")
  }

  tolower(ext[length(ext)])
}

default_gander_style <- function() {
  paste0(
    "Use tidyverse style and, when relevant, tidyverse packages. For example, ",
    "when asked to plot something, use ggplot2, or when asked to transform ",
    "data, using dplyr and/or tidyr unless explicitly instructed otherwise. "
  )
}

get_gander_style <- function() {
  res <- getOption(".gander_style")

  if (!is.null(res)) {
    check_string(res, arg = 'getOption(".gander_style")', call = call2("gander_addin"))
    return(res)
  }

  default_gander_style()
}

# check functions --------------------------------------------------------------
check_gander_chat <- function(x) {
  # adapted from check_function, but errors a bit more informatively
  if (is.null(x)) {
    cli::cli_abort(
      c(
        "gander requires configuring an ellmer Chat with the `.gander_chat` option.",
        "i" = "Set e.g.
        {.code options(.gander_chat = function() {{ellmer::chat_claude()}})}
        in your {.file ~/.Rprofile}.",
        "i" = "See \"Choosing a model\" in
        {.code vignette(\"gander\", package = \"gander\")} to learn more."
      ),
      call = NULL
    )
  }

  res <- x()

  if (!inherits(res, "Chat")) {
    cli::cli_abort(
      c(
        "The option {.code .gander_chat} must be a function that returns
         an ellmer Chat object.",
        "The function returned {.obj_type_friendly {res}} instead."
      ),
      call = NULL
    )
  }

  invisible(NULL)
}
