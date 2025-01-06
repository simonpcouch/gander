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
