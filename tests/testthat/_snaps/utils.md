# get_gander_style validates option value

    Code
      get_gander_style()
    Condition
      Error in `gander_addin()`:
      ! `getOption(".gander_style")` must be a single string, not the number 1.

---

    Code
      get_gander_style()
    Condition
      Error in `gander_addin()`:
      ! `getOption(".gander_style")` must be a single string, not a character vector.

# check_gander_chat errors informatively with bad `.gander_chat`

    Code
      new_chat(.gander_chat = ellmer::chat_openai())
    Message
      Using model = "gpt-4o".
    Condition
      Error:
      ! The .gander_chat option must be a function that returns a Chat, not the Chat object itself.
      i e.g. use `function(x) chat_*()` rather than `chat_*()`.

---

    Code
      new_chat(.gander_chat = function() {
        "boop"
      })
    Condition
      Error:
      ! The option .gander_chat must be a function that returns an ellmer Chat object.
      The function returned a string instead.

---

    Code
      new_chat(.gander_chat = NULL)
    Condition
      Error:
      ! gander requires configuring an ellmer Chat with the .gander_chat option.
      i Set e.g. `options(.gander_chat = function() ellmer::chat_claude())` in your '~/.Rprofile'.
      i See "Choosing a model" in `vignette("gander", package = "gander")` to learn more.

