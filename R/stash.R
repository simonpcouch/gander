gander_env <- new_environment()

stash_last_gander <- function(input, assistant, contents) {
  x <- list(input = input, assistant = assistant, contents = contents)
  gander_env[["last_gander"]] <- x
  invisible(NULL)
}

#' Interface with the previous gander
#'
#' @description
#' `gander_peek()` returns the ellmer `Chat` object from the most recent call
#' to the gander assistant (so you can see what happened under-the-hood).
#'
#' @returns
#' The ellmer `Chat` object from the last assistant interaction,
#' or `NULL` if no previous interaction exists.
#'
#' @export
#' @name last_gander
gander_peek <- function() {
  if (env_has(gander_env, "last_gander")) {
    return(env_get(gander_env, "last_gander")[["assistant"]])
  }

  NULL
}
