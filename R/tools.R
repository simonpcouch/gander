# glimpse data -----------------------------------------------------------------
glimpse_data <- function(x) {
  if (grepl("::", x, fixed = TRUE)) {
    parts <- strsplit(x, "::")[[1]]
    data(list = parts[2], package = parts[1], envir = environment())
    d <- get(parts[2])
  } else {
    d <- env_get(nm = x)
  }

  capture.output(dplyr::glimpse(d))
}

tool_glimpse <-
  ellmer::tool(
    glimpse_data,
    "Show the column names, types, and a few entries for every column in a data frame.
     Each line is a column, like a transposed version of `print()`.
     Use this function when asked to transform variables in an unknown data frame.
     If the name of the data frame is prefixed with a namespace, include the
     namespace in the string, like `'pkg::dataset'`.",
    x = ellmer::type_string(
      "The variable name of the data frame to get a glimpse of, as a string.
       Possibly includes a namespace prefix if the data is from a package."
    )
  )

# fetch function documentation -------------------------------------------------
function_documentation <- function(fn, pkg) {
  loc <- help(fn, package = pkg)
  rlang::eval_bare(rlang::call2(".getHelpFile", file = loc, .ns = "utils"))
}

tool_function_documentation <-
  ellmer::tool(
    function_documentation,
    "A function that provides the documentation of a given function within a
     specified package.",
    fn = ellmer::type_string(
      "The name of the function to fetch documentation for, as a string."
    ),
    pkg = ellmer::type_string(
      "The name of the package in which the function is contained.
       Can be omitted for base packages or functions from unknown packages.",
      required = FALSE
    )
  )

# fetch an image ---------------------------------------------------------------
# TODO: when a model sees a URL or file path to an image, it could call this
# to be passed the output of `content_image_*()`

# putting it all together ------------------------------------------------------
tools <- list(tool_glimpse, tool_function_documentation)
