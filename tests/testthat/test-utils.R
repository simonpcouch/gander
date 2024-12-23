test_that("is_positron() detects env var correctly", {
  withr::local_envvar(POSITRON = NULL)
  expect_false(is_positron())

  withr::local_envvar(POSITRON = "1")
  expect_true(is_positron())

  withr::local_envvar(POSITRON = "0")
  expect_false(is_positron())
})

test_that("ext_to_language works", {
  # converts known cases
  expect_equal(ext_to_language("r"), "R")
  expect_equal(ext_to_language("py"), "Python")

  # returns empty for unknown extensions
  expect_equal(ext_to_language("js"), character(0))
  expect_equal(ext_to_language("txt"), character(0))
})

