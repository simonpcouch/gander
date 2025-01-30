test_that("new_chat fails informatively when old options are present", {
  withr::local_options(
    .gander_fn = "chat_openai",
    .gander_args = list(model = "gpt-4o"),
    .gander_chat = NULL
  )

  expect_snapshot(new_chat(), error = TRUE)

  # still errors well with no (optional) .gander_args
  withr::local_options(.gander_args = NULL)
  expect_snapshot(new_chat(), error = TRUE)
})

test_that("fetch_gander_chat errors informatively with bad `.gander_chat`", {
  skip_if(identical(Sys.getenv("OPENAI_API_KEY"), ""))
  withr::local_options(.gander_fn = NULL, .gander_args = NULL, )

  # .gander_chat is the Chat itself
  expect_snapshot(new_chat(.gander_chat = ellmer::chat_openai()), error = TRUE)

  # .gander_chat is a function that returns the wrong type of thing
  expect_snapshot(new_chat(.gander_chat = function() {"boop"}), error = TRUE)
})


test_that("construct_system_prompt works", {
  # r files
  context <- list(path = "script.r")
  res <- construct_system_prompt(context, input = list())
  expect_match(res, "You are a helpful but terse R data scientist")
  expect_match(res, "valid R code")
  expect_length(res, 1)

  # case insensitive
  context <- list(path = "script.R")
  res <- construct_system_prompt(context, input = list())
  expect_match(res, "You are a helpful but terse R data scientist")
  expect_length(res, 1)

  # other extension
  context <- list(path = "script.md")
  res <- construct_system_prompt(context, input = list())
  expect_match(res, "When asked for code")
  expect_length(res, 1)

  context <- list(path = "README")
  res <- construct_system_prompt(context, input = list())
  expect_match(res, "When asked for code")
  expect_length(res, 1)
})

test_that("construct_turn_impl formats message with file extension", {
  result <- construct_turn_impl(
    input = list(text = "plot it."),
    selection = "",
    code_context = list(before = "mtcars", after = character(0)),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl formats input with punctuation", {
  result <- construct_turn_impl(
    input = list(text = "plot it"),
    selection = "",
    code_context = list(before = "mtcars", after = character(0)),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl includes selection when present", {
  testthat::local_mocked_bindings(file_extension = function(x) "r")

  result <- construct_turn_impl(
    input = list(text = "plot this"),
    selection = "mtcars",
    code_context = list(before = "x <- 1", after = character(0)),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl includes after context when present", {
  testthat::local_mocked_bindings(file_extension = function(x) "r")

  result <- construct_turn_impl(
    input = list(text = "plot this"),
    selection = "",
    code_context = list(before = "x <- 1", after = "z <- 3"),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl includes env context when present", {
  testthat::local_mocked_bindings(file_extension = function(x) "r")

  result <- construct_turn_impl(
    input = list(text = "plot this"),
    selection = "",
    code_context = list(before = "mtcars", after = character(0)),
    env_context = "obj details",
    ext = "R"
  )

  expect_snapshot(cat(result))
})
