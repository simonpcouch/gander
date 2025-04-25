test_that("fetch_env_context works", {
  # to make snaps of character vectors more human-readable, induce a line-break
  # for every element:
  local_options(width = 10)

  env <- new_environment(data = list(a = data.frame(boop = 1), bop = 2))

  expect_snapshot(fetch_env_context("a\nbop <- 1", "do something", env))
  expect_snapshot(fetch_env_context("bop <- 1", "do something", env))
  expect_snapshot(fetch_env_context("a\nmtcars", "do something", env))

  # returns anything split up by spaces if not syntactically valid
  expect_snapshot(fetch_env_context("not valid R code bop", "hey there", env))

  # not in the selection but it's in the input text
  expect_snapshot(fetch_env_context("mtcars", "bop", env))

  # no relevant variables in selection or input
  expect_snapshot(fetch_env_context("", "boop", env))
})

test_that("describe_variable works", {
  local_options(width = 10)

  expect_snapshot(describe_variable(10, "boop"))
  expect_snapshot(describe_variable(data.frame(a = 1, b = 2), "boop"))
})

test_that("backtick_possibly works", {
  expect_equal(backtick_possibly(character(0)), character(0))
  expect_equal(backtick_possibly("x"), c("```", "x", "```"))
  expect_equal(backtick_possibly(c("x", "y")), c("```", "x", "y", "```"))
})

test_that("selected_variables works for r code", {
  seln <- selected_variables(
    '
    ggplot(stackoverflow, aes(x = YearsCodedJob, y = Salary)) +
      geom_point() +
      labs(x = "Years Coded", y = "Salary")
  '
  )

  # todo: this currently includes x and y (argument names) too
  expect_contains(
    seln,
    c(
      "ggplot",
      "stackoverflow",
      "aes",
      "YearsCodedJob",
      "Salary",
      "geom_point",
      "labs"
    )
  )
})

test_that("selected_variables works for unstructured text", {
  seln <- selected_variables("here's some tomfoolery (")
  expect_equal(seln, c("here's", "some", "tomfoolery", "("))
})
