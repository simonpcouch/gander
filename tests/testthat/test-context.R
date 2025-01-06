test_that("fetch_env_context works", {
  # to make snaps of character vectors more human-readable, induce a line-break
  # for every element:
  local_options(width = 10)

  env <- new_environment(data = list(a = data.frame(boop = 1), bop = 2))
  env2 <- new_environment(
    data = list(a = data.frame(boop = 1), bop = data.frame(b = 2))
  )

  expect_snapshot(fetch_env_context("a\nbop <- 1", env))
  expect_snapshot(fetch_env_context("bop <- 1", env))
  expect_snapshot(fetch_env_context("a\nmtcars", env))

  expect_snapshot(fetch_env_context("", env))
  expect_snapshot(fetch_env_context("", env2))
})

test_that("describe_variable works", {
  local_options(width = 10)

  expect_snapshot(describe_variable(10, "boop"))
  expect_snapshot(describe_variable(data.frame(a = 1, b = 2), "boop"))
})

test_that("selected_variable_names works", {
  local_options(width = 10)

  expect_equal(selected_variable_names(""), character(0))
  expect_equal(selected_variable_names("a"), "a")
  expect_equal(selected_variable_names("a <- 1"), "a")
  expect_equal(selected_variable_names("a\nbop <- 1"), c("a", "bop"))
  expect_equal(selected_variable_names("a\nbop(boop)"), c("a", "bop", "boop"))
  expect_equal(selected_variable_names(" a\nbop(boop)"), c("a", "bop", "boop"))
  expect_equal(selected_variable_names("boop <- bop()\nboop"), c("boop", "bop"))
})

test_that("backtick_possibly works", {
  expect_equal(backtick_possibly(character(0)), character(0))
  expect_equal(backtick_possibly("x"), c("```", "x", "```"))
  expect_equal(backtick_possibly(c("x", "y")), c("```", "x", "y", "```"))
})
