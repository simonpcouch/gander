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
#' to the gander assistant so that you can see what happened under-the-hood.
#'
#' Note that gander initializes a new chat every time you invoke the addin,
#' so the token count and conversation history only describes the most recent
#' interaction with the package.
#'
#' @returns
#' The ellmer `Chat` object from the last assistant interaction,
#' or `NULL` if no previous interaction exists.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # First, run the addin to generate a response.
#' gander_addin()
#'
#' # Then, use this function to examine what happened under-the-hood:
#' gander_peek()
#' }
#'
#' @name gander_peek
gander_peek <- function() {
  if (env_has(gander_env, "last_gander")) {
    return(env_get(gander_env, "last_gander")[["assistant"]])
  }

  NULL
}
