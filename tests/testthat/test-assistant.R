test_that("new_chat() uses claude by default", {
  withr::local_options(
    .gander_fn = NULL,
    .gander_args = NULL
  )

  testthat::with_mocked_bindings(
    result <- new_chat(),
    eval_bare = function(call, ...) call,
    .package = "rlang"
  )

  expect_equal(call_name(result), "chat_claude")
  expect_equal(call_ns(result), "ellmer")
})

test_that("new_chat() uses custom function and args", {
  withr::local_options(
    .gander_fn = "chat_openai",
    .gander_args = list(model = "gpt-4o")
  )

  testthat::with_mocked_bindings(
    result <- new_chat(api_args = list(temperature = 0.7)),
    eval_bare = function(call, ...) call,
    .package = "rlang"
  )

  result_args <- call_args(result)
  expect_equal(result_args$model, "gpt-4o")
  expect_equal(result_args$api_args$temperature, 0.7)
  expect_equal(call_name(result), "chat_openai")
  expect_equal(call_ns(result), "ellmer")
})

test_that("new_chat() supplied args override default args", {
  withr::local_options(
    .gander_args = list(temperature = 0.7)
  )

  testthat::with_mocked_bindings(
    result <- new_chat(temperature = 0.9),
    eval_bare = function(call, ...) call,
    .package = "rlang"
  )

  result_args <- call_args(result)
  expect_equal(result_args$temperature, 0.9)
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
    input = "plot it.",
    selection = "",
    code_context = list(before = "mtcars", after = character(0)),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl formats input with punctuation", {
  result <- construct_turn_impl(
    input = "plot it",
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
    input = "plot this",
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
    input = "plot this",
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
    input = "plot this",
    selection = "",
    code_context = list(before = "mtcars", after = character(0)),
    env_context = "obj details",
    ext = "R"
  )

  expect_snapshot(cat(result))
})

