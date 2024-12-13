
<!-- README.md is generated from README.Rmd. Please edit that file -->

# quickly

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/quickly)](https://CRAN.R-project.org/package=quickly)
[![R-CMD-check](https://github.com/simonpcouch/quickly/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/simonpcouch/quickly/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The quickly package allows [elmer](https://elmer.tidyverse.org) chats to
interface directly with your RStudio and Positron sessions. After
(optionally) selecting some code, press the keyboard shortcut you’ve
chosen to trigger the assistant (we suggest `Ctrl+Cmd+H`, as in “help”)
and write your request.

## Installation

You can install quickly like so:

``` r
pak::pak("simonpcouch/quickly")
```

Then, ensure that you have an
[`ANTHROPIC_API_KEY`](https://console.anthropic.com/) environment
variable set, and you’re ready to go. If you’d like to use an LLM other
than Anthropic’s Claude 3.5 Sonnet—like OpenAI’s ChatGPT or a local
ollama model—to power the quickly see `?quickly_options`.

The quickly assistant is interfaced with the via the quickly addin. For
easiest access, we recommend registering the quickly addin to a keyboard
shortcut.

**In RStudio**, navigate to
`Tools > Modify Keyboard Shortcuts > Search "quickly"`—we suggest
`Ctrl+Alt+H` (or `Ctrl+Cmd+H` on macOS).

**In Positron**, you’ll need to open the command palette, run “Open
Keyboard Shortcuts (JSON)”, and paste the following into your
`keybindings.json`:

``` json
    {
        "key": "Ctrl+Cmd+H",
        "command": "workbench.action.executeCode.console",
        "when": "editorTextFocus",
        "args": {
            "langId": "r",
            "code": "quickly::quickly_addin()",
            "focus": true
        }
    }
```

The analogous keybinding on non-macOS is `Ctrl+Alt+H`. That said, change
the `"key"` entry to any keybinding you wish!

Once those steps are completed, you’re ready to use the quickly
assistant with a keyboard shortcut.

## Example

<img src="https://raw.githubusercontent.com/simonpcouch/quickly/refs/heads/main/inst/figs/quickly.gif" alt="A screencast demonstrating usage. In an RStudio session, I select some ggplot code, trigger the addin and type 'add axis labels', and then the model adds the needed code in-place." width="100%" />