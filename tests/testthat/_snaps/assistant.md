# new_chat fails informatively when old options are present

    Code
      .res <- new_chat()
    Message
      ! gander now uses the option gander.chat instead of .gander_fn and .gander_args.
      i Set `options(gander.chat = chat_openai(model = "gpt-4.1"))` instead.

---

    Code
      .res <- new_chat()
    Message
      ! gander now uses the option gander.chat instead of .gander_fn and .gander_args.
      i Set `options(gander.chat = chat_openai())` instead.

# fetch_gander_chat fails informatively with bad `gander.chat`

    Code
      .res <- new_chat(.gander_chat = "boop")
    Message
      ! The option gander.chat must be an ellmer Chat object, not a string.
      i See "Choosing a model" in `vignette("gander", package = "gander")` to learn more.

---

    Code
      .res <- new_chat(.gander_chat = NULL)
    Message
      ! gander requires configuring an ellmer Chat with the gander.chat option.
      i Set e.g. `options(gander.chat = ellmer::chat_claude(model = "claude-sonnet-4-6"))` in your '~/.Rprofile' and restart R.
      i See "Choosing a model" in `vignette("gander", package = "gander")` to learn more.

# fetch_gander_dims handles `gander.dims` appropriately

    Code
      .res <- fetch_gander_dims()
    Message
      ! The option gander.dims must be a 2-length integer vector, e.g. `c(5L, 100L)`, not a string.
      i See `?gander.dims` to learn more.

---

    Code
      .res <- fetch_gander_dims()
    Message
      ! The option gander.dims must be a 2-length integer vector, e.g. `c(5L, 100L)`, not a number.
      i See `?gander.dims` to learn more.

# construct_turn_impl formats message with file contents

    Code
      cat(result)
    Output
      The user is currently working in this file:
      
      `````
      mtcars
      `````
      
      The user made the following request:
      
      > plot it

# construct_turn_impl formats input with punctuation

    Code
      cat(result)
    Output
      The user is currently working in this file:
      
      `````
      mtcars
      `````
      
      The user made the following request:
      
      > plot it

# construct_turn_impl includes selection when present

    Code
      cat(result)
    Output
      The user is currently working in this file:
      
      `````
      x <- 1
      mtcars
      `````
      
      The user made the following request:
      
      > plot this
      
      The user has made the following selection that they'd like to apply the request to:
      
      `````
      mtcars
      `````

# construct_turn_impl with no file contents

    Code
      cat(result)
    Output
      
      The user made the following request:
      
      > plot this

# construct_turn_impl includes env context when present

    Code
      cat(result)
    Output
      The user is currently working in this file:
      
      `````
      mtcars
      `````
      
      The user made the following request:
      
      > plot this
      
      Here's some information about the objects in the user's R environment:
      
      obj details

