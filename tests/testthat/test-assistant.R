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
  expect_equal(call_ns(result), "elmer")
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
  expect_equal(call_ns(result), "elmer")
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
  expect_match(res, "When asked for code")
  expect_length(res, 1)

  # case insensitive
  context <- list(path = "script.R")
  res <- construct_system_prompt(context, input = list())
  expect_match(res, "You are a helpful but terse R data scientist")
  expect_length(res, 1)

  # python
  context <- list(path = "script.py")
  res <- construct_system_prompt(context, input = list())
  expect_match(res, "You are a helpful but terse Python data scientist")
  expect_match(res, "When asked for code")
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

test_that("file_extension works", {
  # returns empty string with no extension
  expect_equal(file_extension("README"), "")
  expect_equal(file_extension("file."), "")
  expect_equal(file_extension("path/to/file"), "")

  # extracts extension correctly
  expect_equal(file_extension("script.r"), "r")
  expect_equal(file_extension("path/to/script.R"), "r")
  expect_equal(file_extension("path.to/script.py"), "py")
  expect_equal(file_extension("script.tar.gz"), "gz")

  # handles special characters in path
  expect_equal(file_extension("file with spaces.txt"), "txt")
  expect_equal(file_extension("path/with.dots/file.md"), "md")
})

test_that("constructs turns correctly with context", {
  input <- list(context = "Selection", text = "my input")
  context <- list(selection = list(list(text = "some context")))

  result <- construct_turn(input, context)
  expect_equal(
    result,
    "my input\n\nHere's some additional context: \n\nsome context"
  )
})

test_that("returns input as-is when None is chosen", {
  input <- list(text = "hey there", context = "None")

  expect_equal(construct_turn(input, list()), "hey there")
})
