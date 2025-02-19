mocked_selection <- function() {
  structure(
    list(
      id = "6588E56E",
      path = "some_file.R",
      contents = "some context",
      selection = structure(
        list(list(
          range = structure(list(
            start = structure(c(row = 1, column = 1), class = "document_position"),
            end = structure(c(row = 1, column = 12), class = "document_position")
          ), class = "document_range"),
          text = "some context"
        )),
        class = "document_selection"
      )
    ),
    class = "document_context"
  )
}

mocked_empty_selection <- function() {
  structure(
    list(
      id = "6588E56E",
      path = "some_file.R",
      contents = "some context",
      selection = structure(
        list(list(
          range = structure(list(
            start = structure(c(row = 1, column = 1), class = "document_position"),
            end = structure(c(row = 1, column = 1), class = "document_position")
          ), class = "document_range"),
          text = ""
        )),
        class = "document_selection"
      )
    ),
    class = "document_context"
  )
}

mocked_chat <- function() {
  readRDS(system.file("chat/chat.rds", package = "gander"))
}
