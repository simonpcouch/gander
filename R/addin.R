#' Run the gander addin
#'
#' @returns
#' Nothing. Called for its side effects, modifying the current RStudio editor
#' based on user input. Will error if no text is entered in the dialog.
#'
#' @export
gander_addin <- function() {
  context <- rstudioapi::getActiveDocumentContext()

  # suppress "Listening on..." message and rethrow errors with new context
  try_fetch(
    suppressMessages(res <- gander_addin_impl(
      has_selection = !identical(rstudioapi::primary_selection(context)$text, "")
    )),
    error = function(cnd) {cli::cli_abort(conditionMessage(cnd), call = NULL)}
  )

  if (is.null(res)) {
    return()
  }

  if (identical(res$text, "")) {
    cli::cli_abort("Please type something to receive a response.", call = NULL)
  }

  do.call(
    paste0("rs_", tolower(res$interface), "_selection"),
    args = list(context = context, input = res)
  )

  invisible()
}

gander_addin_impl <- function(has_selection) {
  minimum_context <- ifelse(has_selection, "Selection", "None")
  ui_elements <- list(
    shiny::textInput("text", "Enter text:",
                     placeholder = "Type your text here"),
    shiny::selectInput("context", "Context:",
                       choices = c(minimum_context, "File", "File & Neighbors")),
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
    ui_elements <- append(ui_elements,
                          list(shiny::selectInput("interface", "Interface:",
                                                  choices = c("Prefix", "Replace", "Suffix"),
                                                  selected = "Replace")))
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
        interface = if (has_selection) input$interface else "Prefix",
        context = input$context
      )
      shiny::stopApp(returnValue = result)
    })

    shiny::onStop(function() {
      shiny::stopApp(returnValue = NULL)
    })
  }

  viewer <- shiny::dialogViewer("Press Enter to submit", width = 300, height = 200)
  shiny::runGadget(ui, server, viewer = viewer)
}
