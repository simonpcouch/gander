# gander (development version)

* Initial CRAN submission.

## Notable changes pre-CRAN submission

Early adopters of the package will note two changes made shortly before the 
release of the package to CRAN:

* The configuration options `.gander_fn` and `.gander_args` have been 
  transitioned to one option, `.gander_chat`. That option takes an ellmer Chat, e.g. 
  `options(.gander_chat = ellmer::chat_claude())`.
  If you've configured an ellmer model using the previous options, you'll get
  an error that automatically translates to the new code you need to use.
  
* There is no longer a default ellmer model. Early in the development
  of gander, if you had an `ANTHROPIC_API_KEY` set up, the addin would
  "just work." While this was convenient for Claude users, it means that the 
  package spends money on the users behalf without any explicit opt-in.
