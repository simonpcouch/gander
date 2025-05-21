# Creates an example Chat object to test against.
ch <- ellmer::chat_anthropic()

ch$chat("What's 2+2?")

ch$.__enclos_env__$private$provider <- ellmer::Provider(
  "Anthropic",
  "claude-3-7-sonnet-latest",
  "example.org"
)

saveRDS(ch, file = "inst/chat/chat.rds")
