# Options used by the gander package

The gander package makes use of a few notable user-facing options.

## Choosing models

gander uses the `gander.chat` option to configure which model powers the
addin. `gander.chat` is an ellmer Chat object. For example, to use
Anthropic's Claude Sonnet 4.6, you might write

    options(gander.chat = ellmer::chat_claude(model = "claude-sonnet-4-6"))

Paste that code in your `.Rprofile` via `usethis::edit_r_profile()` to
always use the same model every time you start an R session.

The legacy option `.gander_chat` is also supported. The gander package
used to use options `.gander_fn` and `.gander_args`, but those are
deprecated in favor of `gander.chat`.

## Style/taste

By default, gander responses use the following style conventions: "Use
tidyverse style and, when relevant, tidyverse packages. For example,
when asked to plot something, use ggplot2, or when asked to transform
data, using dplyr and/or tidyr unless explicitly instructed otherwise. "
Set the `gander.style` option to some other string to tailor responses
to your own taste, e.g.:

    options(gander.style = "Use base R.")

Paste that code in your `.Rprofile` via `usethis::edit_r_profile()` to
always use the same style (or even always begin with some base set of
knowledge about frameworks you work with often) every time you start an
R session. The legacy option `.gander_style` is also supported.

## Data context

By default, gander will show the first 5 rows and 100 columns of every
relevant data frame, allowing for models to pick up on the names, types,
and distributions of the variables it may work with while also keeping
the number of tokens submitted per chat to a minimum. The option
`gander.dims` allows you to adjust how many rows and columns to supply
to gander addin.

- For richer context but increasing token usage, increase the number of
  rows and columns. For example, to supply the first 50 rows and all
  columns of datasets supplied to the model, you could use
  `options(gander.dims = c(50, Inf))`.

- To decrease token usage, decrease the number of rows and columns, e.g.
  `options(gander.dims = c(0, 10))` to just show the names and types of
  the first 10 columns. One could make the argument that setting the
  number of rows to 0 is privacy-preserving, but do note that the model
  may pick up on the values of specific cells based on code context
  alone. To learn more, see <https://posit.co/blog/trust-llm-tools/>.

Set that option in your `~/.Rprofile` to always use that setting. The
legacy option `.gander_dims` is also supported.

## Examples

``` r
# Running the following will adjust R options, so don't run by default:
if (FALSE) { # \dontrun{
# Describe the first 100 rows and every column in relevant data
# frames rather than the first 5 rows and 100 columns (this can
# increase token usage greatly):
options(gander.dims = c(100, Inf))

# Only describe relevant data frame columns and their types, but don't
# provide any rows:
options(gander.dims = c(0, Inf))

# Override default tidyverse style to tell the model to prefer another style:
options(gander.style = "Use base R.")

# Configure gander to use its recommended model, Anthropic's Claude Sonnet
# 4.6. Set this option in your `~/.Rprofile` to always use this setting.
# Note that this requires an `ANTHROPIC_API_KEY` envvar:
options(gander.chat = ellmer::chat_claude(model = "claude-sonnet-4-6"))
} # }
```
