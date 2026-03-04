test_that("new_chat fails informatively when old options are present", {
  withr::local_options(
    .gander_fn = "chat_openai",
    .gander_args = list(model = "gpt-4.1"),
    gander.chat = NULL,
    .gander_chat = NULL
  )

  expect_snapshot(.res <- new_chat())

  # still errors well with no (optional) .gander_args
  withr::local_options(.gander_args = NULL)
  expect_snapshot(.res <- new_chat())
})

test_that("fetch_gander_chat fails informatively with bad `gander.chat`", {
  skip_if(identical(Sys.getenv("OPENAI_API_KEY"), ""))
  withr::local_options(.gander_fn = NULL, .gander_args = NULL)

  # gander.chat is the wrong type of thing
  expect_snapshot(
    .res <- new_chat(.gander_chat = "boop")
  )
  expect_null(.res)

  # no gander.chat at all
  expect_snapshot(
    .res <- new_chat(.gander_chat = NULL)
  )
  expect_null(.res)
})

test_that("fetch_gander_dims handles `gander.dims` appropriately", {
  # default case, no option set
  withr::local_options(gander.dims = NULL, .gander_dims = NULL)
  expect_equal(fetch_gander_dims(), default_gander_dims)

  # wrong type
  withr::local_options(gander.dims = "boop", .gander_dims = NULL)
  expect_snapshot(.res <- fetch_gander_dims())
  expect_equal(.res, NULL)

  # wrong length
  withr::local_options(gander.dims = 5, .gander_dims = NULL)
  expect_snapshot(.res <- fetch_gander_dims())
  expect_equal(.res, NULL)

  # Inf is ok
  withr::local_options(gander.dims = c(5, Inf), .gander_dims = NULL)
  expect_equal(fetch_gander_dims(), c(5, Inf))

  # both Inf is ok
  withr::local_options(gander.dims = c(Inf, Inf), .gander_dims = NULL)
  expect_equal(fetch_gander_dims(), c(Inf, Inf))
})

test_that("fetch_gander_dims works with legacy `.gander_dims` option", {
  withr::local_options(gander.dims = NULL, .gander_dims = c(10, 50))
  expect_equal(fetch_gander_dims(), c(10, 50))
})

test_that("get_gander_chat prefers gander.chat over .gander_chat", {
  withr::local_options(gander.chat = NULL, .gander_chat = NULL)
  expect_null(get_gander_chat())

  mock_chat_old <- structure(list(id = "old"), class = "Chat")
  mock_chat_new <- structure(list(id = "new"), class = "Chat")

  withr::local_options(gander.chat = NULL, .gander_chat = mock_chat_old)
  expect_identical(get_gander_chat(), mock_chat_old)

  withr::local_options(gander.chat = mock_chat_new, .gander_chat = NULL)
  expect_identical(get_gander_chat(), mock_chat_new)

  withr::local_options(gander.chat = mock_chat_new, .gander_chat = mock_chat_old)
  expect_identical(get_gander_chat(), mock_chat_new)
})

test_that("get_gander_dims prefers gander.dims over .gander_dims", {
  withr::local_options(gander.dims = NULL, .gander_dims = NULL)
  expect_null(get_gander_dims())

  withr::local_options(gander.dims = NULL, .gander_dims = c(10, 50))
  expect_equal(get_gander_dims(), c(10, 50))

  withr::local_options(gander.dims = c(20, 200), .gander_dims = NULL)
  expect_equal(get_gander_dims(), c(20, 200))

  withr::local_options(gander.dims = c(20, 200), .gander_dims = c(10, 50))
  expect_equal(get_gander_dims(), c(20, 200))
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

test_that("construct_system_prompt appends task instruction when selection present", {
  context <- list(path = "script.r")

  res_no_sel <- construct_system_prompt(context, input = list(), has_selection = FALSE)
  expect_no_match(res_no_sel, "apply the user's request")


  res_sel <- construct_system_prompt(context, input = list(), has_selection = TRUE)
  expect_match(res_sel, "apply the user's request to their selected text")
  expect_match(res_sel, "Return only the replacement text")
})

test_that("construct_turn_impl formats message with file contents", {
  result <- construct_turn_impl(
    user_prompt = "plot it.",
    code_context = list(
      file_contents = c("`````", "mtcars", "`````"),
      selection = character(0)
    ),
    env_context = character(0)
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl formats input with punctuation", {
  result <- construct_turn_impl(
    user_prompt = "plot it",
    code_context = list(
      file_contents = c("`````", "mtcars", "`````"),
      selection = character(0)
    ),
    env_context = character(0)
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl includes selection when present", {
  result <- construct_turn_impl(
    user_prompt = "plot this",
    code_context = list(
      file_contents = c("`````", "x <- 1", "mtcars", "`````"),
      selection = c("`````", "mtcars", "`````"),
      selection_raw = "mtcars"
    ),
    env_context = character(0)
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl with no file contents", {
  result <- construct_turn_impl(
    user_prompt = "plot this",
    code_context = list(
      file_contents = character(0),
      selection = character(0)
    ),
    env_context = character(0)
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl includes env context when present", {
  result <- construct_turn_impl(
    user_prompt = "plot this",
    code_context = list(
      file_contents = c("`````", "mtcars", "`````"),
      selection = character(0)
    ),
    env_context = "obj details"
  )

  expect_snapshot(cat(result))
})

test_that("construct_turn_impl appends no-backtick reminder when selection has no backticks", {
  result <- construct_turn_impl(
    user_prompt = "refactor this",
    code_context = list(
      file_contents = c("`````", "x <- 1", "`````"),
      selection = c("`````", "x <- 1", "`````"),
      selection_raw = "x <- 1"
    ),
    env_context = character(0)
  )

  expect_match(result, "Do not include backticks")
})

test_that("construct_turn_impl explains five-backtick fences when selection contains backticks", {
  result <- construct_turn_impl(
    user_prompt = "edit this chunk",
    code_context = list(
      file_contents = c("`````", "```{r}", "x <- 1", "```", "`````"),
      selection = c("`````", "```{r}", "x <- 1", "```", "`````"),
      selection_raw = "```{r}\nx <- 1\n```"
    ),
    env_context = character(0)
  )

  expect_match(result, "five-backtick fences")
  expect_match(result, "should not include the five-backtick fences")
  expect_no_match(result, "Do not include backticks or code fences")
})

test_that("construct_turn_impl omits no-backtick reminder when no selection", {
  result <- construct_turn_impl(
    user_prompt = "add a plot",
    code_context = list(
      file_contents = c("`````", "mtcars", "`````"),
      selection = character(0),
      selection_raw = ""
    ),
    env_context = character(0)
  )

  expect_no_match(result, "Do not include backticks")
})
