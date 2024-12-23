test_that("describe_selected_variables works", {
  env <- new_environment(data = list(a = data.frame(boop = 1), bop = 2))
  env2 <- new_environment(
    data = list(a = data.frame(boop = 1), bop = data.frame(b = 2))
  )

  expect_snapshot(describe_relevant_variables("a\nbop <- 1", env))
  expect_snapshot(describe_relevant_variables("bop <- 1", env))
  expect_snapshot(describe_relevant_variables("a\nmtcars", env))

  expect_snapshot(describe_relevant_variables("", env))
  expect_snapshot(describe_relevant_variables("", env2))
})

test_that("describe_variable works", {
  expect_snapshot(describe_variable(10, "boop"))
  expect_snapshot(describe_variable(data.frame(a = 1, b = 2), "boop"))
})

test_that("selected_variable_names works", {
  expect_equal(selected_variable_names(""), character(0))
  expect_equal(selected_variable_names("a"), "a")
  expect_equal(selected_variable_names("a <- 1"), "a")
  expect_equal(selected_variable_names("a\nbop <- 1"), c("a", "bop"))
  expect_equal(selected_variable_names("a\nbop(boop)"), c("a", "bop", "boop"))
  expect_equal(selected_variable_names(" a\nbop(boop)"), c("a", "bop", "boop"))
  expect_equal(selected_variable_names("boop <- bop()\nboop"), c("boop", "bop"))
})
