
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gander <a href="https://simonpcouch.github.io/gander/"><img src="man/figures/logo.png" align="right" height="240" alt="gander website" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/gander)](https://CRAN.R-project.org/package=gander)
[![R-CMD-check](https://github.com/simonpcouch/gander/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/simonpcouch/gander/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

gander is a higher-performance and lower-friction chat experience for
data scientists in RStudio and Positron–sort of like completions with
Copilot, but it knows how to talk to the objects in your R environment.
The package brings [ellmer](https://ellmer.tidyverse.org) chats into
your project sessions, automatically incorporating relevant context and
streaming their responses directly into your documents.

**Why not just chat?** In many ways, working with gander is just like
using a chat interface online or via
[shinychat](https://github.com/jcheng5/shinychat). The gander assistant
will automatically find the context it needs, though:

- **Code context**: File contents from elsewhere in the project you’re
  working on (e.g. the lines in your source file).
- **Environment context**: Variables, allowing the assistant to locate
  the column names and types in data frames you’re working with, images
  linked to in your documents, and function definitions. This is what
  differentiates gander from many other assistants out there; gander can
  interface with your R session to describe your computational
  environment.

> **Important**
>
> For now, gander is particularly effective in `.R` files but struggles
> to provide appropriately formatted responses in `.Qmd` and related
> file formats.

## Installation

You can install gander like so:

``` r
pak::pak("simonpcouch/gander")
```

Then, you’ll need to hook gander up with an [ellmer
chat](https://ellmer.tidyverse.org/). gander uses the `.gander_chat`
option to configure which model powers the addin; just set the option to
whatever your usual ellmer setup is. For example, we recommend
Anthropic’s Claude Sonnet 3.5, which you can use via
`options(.gander_chat = ellmer::chat_claude())` once you’ve configured
an `ANTHROPIC_API_KEY`. Paste that code in your `.Rprofile` via
`usethis::edit_r_profile()` to always use the same model every time you
start an R session. gander supports any model supported by ellmer, so
you can use Anthropic’s Claude, OpenAI’s GPT-4o, local ollama models,
etc. See “Choosing a model” in `vignette("gander", package = "gander")`
to learn more.

The gander assistant is interfaced with the via the gander addin. For
easiest access, we recommend registering the gander addin to a keyboard
shortcut.

**In RStudio**, navigate to
`Tools > Modify Keyboard Shortcuts > Search "gander"`—we suggest
`Ctrl+Alt+G` (or `Ctrl+Cmd+G` on macOS).

**In Positron**, you’ll need to open the command palette, run “Open
Keyboard Shortcuts (JSON)”, and paste the following into your
`keybindings.json`:

``` json
    {
        "key": "Ctrl+Cmd+G",
        "command": "workbench.action.executeCode.console",
        "when": "editorTextFocus",
        "args": {
            "langId": "r",
            "code": "gander::gander_addin()",
            "focus": true
        }
    }
```

The analogous keybinding on non-macOS is `Ctrl+Alt+G`. That said, change
the `"key"` entry to any keybinding you wish!

Once those steps are completed, you’re ready to use the gander assistant
with a keyboard shortcut.

## Example

This screencast demonstrates using the gander addin to iterate on a
plot:

<img src="https://github.com/user-attachments/assets/4aead453-c2f2-446b-8e81-9154fd3baab0" alt="A screencast of an RStudio session. A script called example.R is open in the editor with lines library(ggplot2), data(stackoverflow), and stackoverflow. After highlighting, I trigger the addin and ask to plot the data in plain language, at which code to plot the data using ggplot2 is streamed from an LLM into the source file that uses the correct column names and a minimal style. From there, I iteratively call the addin to refine the output." width="100%" />

After loading the stackoverflow data into my environment, I highlight
`stackoverflow` and type a plain language request to plot the data. The
LLM’s response—which provides a minimal solution and refers to correct
column names—is streamed directly into my document and selected in
whole. After visually inspecting, I run the code, and then retrigger the
addin and type a followup request to refine the plot, doing so
iteratively until I’m satisfied with my results.

To read more about using the addin, check out the Getting Started
vignette with `vignette("gander", package = "gander")`.
