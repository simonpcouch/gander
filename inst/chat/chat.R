# Creates an example Chat object to test against.
ch <- ellmer::chat_anthropic()

ch$chat("What's 2+2?")

saveRDS(ch, file = "inst/chat/chat.rds")
