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
