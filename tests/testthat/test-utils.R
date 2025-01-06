test_that("is_positron() detects env var correctly", {
  withr::local_envvar(POSITRON = NULL)
  expect_false(is_positron())

  withr::local_envvar(POSITRON = "1")
  expect_true(is_positron())

  withr::local_envvar(POSITRON = "0")
  expect_false(is_positron())
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
