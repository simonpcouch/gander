test_that("gander_env is initialized", {
  expect_true(is.environment(gander_env))
})

test_that("gander_peek works", {
  ch <- mocked_chat()

  stash_last_gander("What's 2+2?", ch, list())

  ch_peeked <- gander_peek()
  expect_equal(ch, ch_peeked)

  expect_true(env_has(gander_env, "last_gander"))
})
