test_that("new_chat fails informatively when old options are present", {
  withr::local_options(
    .gander_fn = "chat_openai",
    .gander_args = list(model = "gpt-4o"),
    .gander_chat = NULL
  )

  expect_snapshot(.res <- new_chat())

  # still errors well with no (optional) .gander_args
  withr::local_options(.gander_args = NULL)
  expect_snapshot(.res <- new_chat())
})

test_that("fetch_gander_chat fails informatively with bad `.gander_chat`", {
  skip_if(identical(Sys.getenv("OPENAI_API_KEY"), ""))
  withr::local_options(.gander_fn = NULL, .gander_args = NULL, )

  # .gander_chat is the wrong type of thing
  expect_snapshot(
    .res <- new_chat(.gander_chat = "boop")
  )
  expect_null(.res)

  # no .gander_chat at all
  expect_snapshot(
    .res <- new_chat(.gander_chat = NULL)
  )
  expect_null(.res)
})

test_that("fetch_gander_dims handles `.gander_dims` appropriately", {
  # default case, no option set
  withr::local_options(.gander_dims = NULL)
  expect_equal(fetch_gander_dims(), default_gander_dims)

  # wrong type
  withr::local_options(.gander_dims = "boop")
  expect_snapshot(.res <- fetch_gander_dims())
  expect_equal(.res, NULL)

  # wrong length
  withr::local_options(.gander_dims = 5)
  expect_snapshot(.res <- fetch_gander_dims())
  expect_equal(.res, NULL)

  # Inf is ok
  withr::local_options(.gander_dims = c(5, Inf))
  expect_equal(fetch_gander_dims(), c(5, Inf))

  # both Inf is ok
  withr::local_options(.gander_dims = c(Inf, Inf))
  expect_equal(fetch_gander_dims(), c(Inf, Inf))
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
    user_prompt = "plot it.",
    code_context = list(before = "mtcars", after = "", selection = ""),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl formats input with punctuation", {
  result <- construct_turn_impl(
    user_prompt = "plot it",
    code_context = list(before = "mtcars", after = "", selection = ""),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl includes selection when present", {
  testthat::local_mocked_bindings(file_extension = function(x) "r")

  result <- construct_turn_impl(
    user_prompt = "plot this",
    code_context = list(before = "x <- 1", after = "", selection = "mtcars"),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl includes after context when present", {
  testthat::local_mocked_bindings(file_extension = function(x) "r")

  result <- construct_turn_impl(
    user_prompt = "plot this",
    code_context = list(before = "x <- 1", after = "z <- 3", selection = ""),
    env_context = character(0),
    ext = "R"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl includes env context when present", {
  testthat::local_mocked_bindings(file_extension = function(x) "r")

  result <- construct_turn_impl(
    user_prompt = "plot this",
    code_context = list(before = "mtcars", after = "", selection = ""),
    env_context = "obj details",
    ext = "R"
  )

  expect_snapshot(cat(result))
})
