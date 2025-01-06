#' Run the gander addin
#'
#' The gander addin is intended to be called using the RStudio addin rather
#' than explicitly by the user. See `vignette("gander", package = "gander")`
#' to learn more about using the gander addin.
#'
#' @returns
#' The underlying ellmer Chat, invisibly. Primarily called for its side effects,
#' modifying the current RStudio editor based on user input. Will error if
#' no text is entered in the dialog.
#'
#' @export
gander_addin <- function() {
  context <- rstudioapi::getActiveDocumentContext()

  # suppress "Listening on..." message and rethrow errors with new context
  try_fetch(
    suppressMessages(input <- gander_addin_impl(
      has_selection = !identical(rstudioapi::primary_selection(context)$text, "")
    )),
    error = function(cnd) {cli::cli_abort(conditionMessage(cnd), call = NULL)}
  )

  if (is.null(input)) {
    return()
  }

  if (identical(input$text, "")) {
    cli::cli_abort("Please type something to receive a response.", call = NULL)
  }

  assistant <- initialize_assistant(context = context, input = input)
  turn <- construct_turn(input = input, context = context)

  edits <-
    streamy::stream(
      generator = assistant$stream(turn),
      context = context,
      interface = tolower(input$interface)
    )

  contents <- list(before = context$selection, after = edits)

  stash_last_gander(
    input = input, assistant = assistant, contents = contents
  )

  if (is_positron()) {
    .ps.ui.executeCommand("workbench.action.focusActiveEditorGroup")
  }
  
  cli::cli_inform(
    "Use {.run gander::gander_undo()} or {.run gander::gander_retry()} if needed."
  )

  invisible(assistant)
}

gander_addin_impl <- function(has_selection) {
  minimum_context <- ifelse(has_selection, "Selection", "None")
  ui_elements <- list(
    shiny::textInput("text", "Enter text:",
                     placeholder = "Type your text here"),
    shiny::tags$script(shiny::HTML("
      $(document).on('keyup', function(e) {
        if(e.key == 'Enter'){
          Shiny.setInputValue('done', true, {priority: 'event'});
        }
      });
      $(document).ready(function() {
        $('#text').focus();
      });
    "))
  )

  if (has_selection) {
    ui_elements <- append(
      ui_elements,
      list(shiny::selectInput(
        "interface",
        "Interface:",
        choices = c("Prefix", "Replace", "Suffix"),
        selected = gander_env[["last_interface"]] %||% "Replace"
      ))
    )
  }

  ui <- miniUI::miniPage(
    miniUI::miniContentPanel(
      ui_elements
    )
  )

  server <- function(input, output, session) {
    shiny::observeEvent(input$done, {
      result <- list(
        text = input$text,
        interface = if (has_selection) input$interface else "Prefix"
      )
      gander_env[["last_interface"]] <- result$interface
      shiny::stopApp(returnValue = result)
    })

    shiny::onStop(function() {
      shiny::stopApp(returnValue = NULL)
    })
  }

  viewer <- shiny::dialogViewer("Press Enter to submit", width = 300, height = 200)
  shiny::runGadget(ui, server, viewer = viewer)
}
