# new_chat fails informatively when old options are present

    Code
      .res <- new_chat()
    Message
      ! gander now uses the option .gander_chat instead of .gander_fn and .gander_args.
      i Set `options(.gander_chat = function() {chat_openai(model = "gpt-4o")})` instead.

---

    Code
      .res <- new_chat()
    Message
      ! gander now uses the option .gander_chat instead of .gander_fn and .gander_args.
      i Set `options(.gander_chat = function() {chat_openai()})` instead.

# fetch_gander_chat fails informatively with bad `.gander_chat`

    Code
      .res <- new_chat(.gander_chat = ellmer::chat_openai(model = "gpt-4o"))
    Message
      ! The .gander_chat option must be a function that returns a Chat, not the Chat object itself.
      i e.g. use `function(x) chat_*()` rather than `chat_*()`.

---

    Code
      .res <- new_chat(.gander_chat = function() {
        "boop"
      })
    Message
      ! The option .gander_chat must be a function that returns an ellmer Chat object.
      The function returned a string instead.

---

    Code
      .res <- new_chat(.gander_chat = NULL)
    Message
      ! gander requires configuring an ellmer Chat with the .gander_chat option.
      i Set e.g. `options(.gander_chat = function() ellmer::chat_claude())` in your '~/.Rprofile'.
      i See "Choosing a model" in `vignette("gander", package = "gander")` to learn more.

# construct_turn_impl formats message with file extension

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      mtcars
      
      plot it.

# construct_turn_impl formats input with punctuation

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      mtcars
      
      plot it.

# construct_turn_impl includes selection when present

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      x <- 1
      
      Now, plot this: 
      
      mtcars

# construct_turn_impl includes after context when present

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      x <- 1
      
      plot this.
      
      For context, the rest of the file reads: 
      
      z <- 3

# construct_turn_impl includes env context when present

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      mtcars
      
      plot this.
      
      Here's some information about the objects in my R environment: 
      
      obj details

