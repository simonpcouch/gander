gander_env <- new_environment()

stash_last_gander <- function(input, assistant, contents) {
  x <- list(input = input, assistant = assistant, contents = contents)
  gander_env[["last_gander"]] <- x
  invisible(NULL)
}

#' Interface with the previous gander
#'
#' @description
#' These functions interface with the most recent call to the
#' gander assistant:
#'
#' * `gander_peek()` returns the ellmer `Chat` object (so you can see what
#'    happened under-the-hood).
#' * `gander_undo()` reverts the gander assistant's edits.
#' * `gander_retry()` submits the same input to the model, replacing the
#'    previous gander with new input.
#'
# Undoing and retrying are not available if there have been edits to the
# document since the previous gander.
#
#' @export
#' @name last_gander
gander_peek <- function() {
  env_get(gander_env, "last_gander")[["assistant"]]
}

#' @export
#' @rdname last_gander
gander_undo <- function() {
  last_gander <- env_get(gander_env, "last_gander")

  # range rows are off-by-one
  # TODO: check that this is also the case in Positron
  ranges <- last_gander$contents$after$ranges
  ranges[[1]][c(1, 3)] <- ranges[[1]][c(1, 3)] + 1

  invisible(
    rstudioapi::modifyRange(
      location = ranges,
      text = last_gander$contents$before[[1]]$text,
      id = last_gander$contents$after$id
    )
  )
}

#' @export
#' @rdname last_gander
gander_retry <- function() {
  last_gander <- env_get(gander_env, "last_gander")

  chat <- last_gander$assistant
  turns <- chat$get_turns()
  chat$set_turns(list())

  # range rows are off-by-one
  ranges <- last_gander$contents$after$ranges
  ranges[[1]][c(1, 3)] <- ranges[[1]][c(1, 3)] + 1

  invisible(
    streamy::stream(
      generator = chat$stream(last_user_turn(turns)),
      context = rstudioapi::getSourceEditorContext(
        id = last_gander$contents$after$id
      ),
      interface = tolower(last_gander$input$interface)
    )
  )
}

wipe_last_turn <- function(chat) {
  chat$set_turns()
}

last_user_turn <- function(turns) {
  roles <- purrr::map_chr(turns, function(turn) turn@role)
  user_turn_locs <- which(roles == "user")
  last_user_turn <- turns[user_turn_locs[length(user_turn_locs)]][[1]]
  last_user_turn@text
}
