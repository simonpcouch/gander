
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gander

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/gander)](https://CRAN.R-project.org/package=gander)
[![R-CMD-check](https://github.com/simonpcouch/gander/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/simonpcouch/gander/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

gander is a higher-performance and lower-friction chat experience for
data scientists in RStudio and Positron. The package brings
[ellmer](https://ellmer.tidyverse.org) chats into your project sessions,
automatically incorporating relevant context and streaming their
responses directly into your documents.

**Why not just chat?** In many ways, working with gander is just like
using a chat interface online or via
[shinychat](https://github.com/jcheng5/shinychat). The gander assistant
will automatically find the context it needs, though:

- Variables, allowing the assistant to locate the column names and types
  in data frames you’re working with, images linked to in your
  documents, and function definitions
- File contents from elsewhere in the project you’re working on
  (e.g. the lines in your source file)

## Installation

You can install gander like so:

``` r
pak::pak("simonpcouch/gander")
```

Then, ensure that you have an
[`ANTHROPIC_API_KEY`](https://console.anthropic.com/) environment
variable set, and you’re ready to go. If you’d like to use an LLM other
than Anthropic’s Claude 3.5 Sonnet—like OpenAI’s GPT-4o or a local
ollama model—and then set the `.gander_fn` and `.gander_args` options in
your `.Rprofile`, like `options(.gander_fn = "chat_openai")` to use
OpenAI’s GPT-4o or
`options(.gander_fn = "chat_openai", .gander_args = list(model = "gpt-4o-mini"))`
to use their GPT-4o-mini model.

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

<iframe src="https://github.com/user-attachments/assets/8d28a2c8-9f8c-47eb-940d-9f1586d2e9bb" width="100%" height="400px" data-external="1">
</iframe>
