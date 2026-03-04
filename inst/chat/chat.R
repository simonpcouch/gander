# Creates an example Chat object to test against.
ch <- ellmer::chat_claude(model = "claude-sonnet-4-6")

ch$chat("What's 2+2?")

ch$.__enclos_env__$private$provider <- ellmer::Provider(
  "Anthropic",
  "claude-sonnet-4-6",
  "example.org"
)

saveRDS(ch, file = "inst/chat/chat.rds")
