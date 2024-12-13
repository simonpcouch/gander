test_that("is_positron() detects env var correctly", {
  withr::local_envvar(POSITRON = NULL)
  expect_false(is_positron())

  withr::local_envvar(POSITRON = "1")
  expect_true(is_positron())

  withr::local_envvar(POSITRON = "0")
  expect_false(is_positron())
})
