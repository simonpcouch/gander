# miscellaneous ----------------------------------------------------------------
interactive <- NULL

is_positron <- function() {
  Sys.getenv("POSITRON") == "1"
}

global_env <- function() {
  .GlobalEnv
}
