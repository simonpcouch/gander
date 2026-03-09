# gander 0.2.0

* Improved performance in Quarto documents. Requests made in Quarto 
  documents should now be much less likely to break cell formatting (#30).

* Introduced `gander.chat`, `gander.style`, and `gander.dims` as the preferred
  option names, following standard R package option naming conventions. The
  legacy options `.gander_chat`, `.gander_style`, and `.gander_dims` continue
  to work and will not be deprecated.

* Updated recommended models to Claude Sonnet 4.6, GPT-4.1, and Gemini 3 
  Flash.

* Rewrote prompt structure to more clearly communicate the agent's task.
  This should broadly result in stronger understanding of user requests
  and stronger adherence to system instructions (#67).

# gander 0.1.0

* Initial CRAN submission.

## Notable changes pre-CRAN submission

Early adopters of the package will note two changes made shortly before the 
release of the package to CRAN:

* The configuration options `.gander_fn` and `.gander_args` have been 
  transitioned to one option, `.gander_chat`. That option takes an ellmer Chat, e.g. 
  `options(.gander_chat = ellmer::chat_anthropic())`.
  If you've configured an ellmer model using the previous options, you'll get
  an error that automatically translates to the new code you need to use.
  
* There is no longer a default ellmer model. Early in the development
  of gander, if you had an `ANTHROPIC_API_KEY` set up, the addin would
  "just work." While this was convenient for Claude users, it means that the 
  package spends money on the users behalf without any explicit opt-in.
