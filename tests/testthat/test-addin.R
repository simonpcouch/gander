test_that("gander_addin requests a content stream", {
  context <- mocked_empty_selection()
  stream_type <- NULL
  assistant <- list(
    stream = function(turn, stream) {
      stream_type <<- stream
      NULL
    }
  )

  testthat::local_mocked_bindings(
    new_chat = function() assistant,
    gander_addin_impl = function(has_selection) {
      list(text = "Do something", interface = "Prefix")
    },
    initialize_assistant = function(context, input, chat) assistant,
    construct_turn = function(user_prompt, context) "turn",
    stash_last_gander = function(input, assistant, contents) NULL
  )
  testthat::local_mocked_bindings(
    getActiveDocumentContext = function() context,
    primary_selection = function(context) context$selection[[1]],
    .package = "rstudioapi"
  )
  testthat::local_mocked_bindings(
    stream = function(generator, context, interface) {
      force(generator)
      "answer"
    },
    .package = "streamy"
  )

  expect_invisible(gander_addin())
  expect_identical(stream_type, "content")
})
