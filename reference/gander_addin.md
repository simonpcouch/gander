# Run the gander addin

The gander addin is intended to be called using the RStudio addin rather
than explicitly by the user. See
[`vignette("gander", package = "gander")`](https://simonpcouch.github.io/gander/articles/gander.md)
to learn more about using the gander addin.

## Usage

``` r
gander_addin()
```

## Value

The underlying ellmer Chat, invisibly. Primarily called for its side
effects, modifying the current RStudio editor based on user input. Will
error if no text is entered in the dialog.

## Examples

``` r
if (FALSE) { # \dontrun{
# Requires an interactive session, access to the RStudio API,
# and an active connection to an LLM API.
gander_addin()
} # }
```
