# miscellaneous ----------------------------------------------------------------
interactive <- NULL

is_positron <- function() {
  Sys.getenv("POSITRON") == "1"
}

ext_to_language <- function(ext) {
  switch(
    ext,
    r = "R",
    py = "Python",
    character(0)
  )
}
