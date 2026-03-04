# Interface with the previous gander

`gander_peek()` returns the ellmer `Chat` object from the most recent
call to the gander assistant so that you can see what happened
under-the-hood.

Note that gander initializes a new chat every time you invoke the addin,
so the token count and conversation history only describes the most
recent interaction with the package.

## Usage

``` r
gander_peek()
```

## Value

The ellmer `Chat` object from the last assistant interaction, or `NULL`
if no previous interaction exists.

## Examples

``` r
if (FALSE) { # \dontrun{
# First, run the addin to generate a response.
gander_addin()

# Then, use this function to examine what happened under-the-hood:
gander_peek()
} # }
```
