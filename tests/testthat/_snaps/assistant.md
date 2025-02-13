# new_chat fails informatively when old options are present

    Code
      .res <- new_chat()
    Message
      ! gander now uses the option .gander_chat instead of .gander_fn and .gander_args.
      i Set `options(.gander_chat = chat_openai(model = "gpt-4o"))` instead.

---

    Code
      .res <- new_chat()
    Message
      ! gander now uses the option .gander_chat instead of .gander_fn and .gander_args.
      i Set `options(.gander_chat = chat_openai())` instead.

# fetch_gander_chat fails informatively with bad `.gander_chat`

    Code
      .res <- new_chat(.gander_chat = "boop")
    Message
      ! The option .gander_chat must be an ellmer Chat object, not a string.
      i See "Choosing a model" in `vignette("gander", package = "gander")` to learn more.

---

    Code
      .res <- new_chat(.gander_chat = NULL)
    Message
      ! gander requires configuring an ellmer Chat with the .gander_chat option.
      i Set e.g. `options(.gander_chat = ellmer::chat_claude())` in your '~/.Rprofile' and restart R.
      i See "Choosing a model" in `vignette("gander", package = "gander")` to learn more.

# fetch_gander_dims handles `.gander_dims` appropriately

    Code
      .res <- fetch_gander_dims()
    Message
      ! The option .gander_dims must be a 2-length integer vector, e.g. `c(5L, 100L)`, not a string.
      i See `?.gander_dims` to learn more.

---

    Code
      .res <- fetch_gander_dims()
    Message
      ! The option .gander_dims must be a 2-length integer vector, e.g. `c(5L, 100L)`, not a number.
      i See `?.gander_dims` to learn more.

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

