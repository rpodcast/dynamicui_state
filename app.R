library(shiny)

ui <- fluidPage(
  h2("Dynamic UI Generation"),

  fluidRow(
    column(
      width = 6,
      # placeholder for UI elements
      div(id = "add_inputs_here")
    ),
    column(
      width = 6,
      verbatimTextOutput("values")
    )
  ),

  fluidRow(
    actionButton("add_inputs", "Add Inputs"),
    actionButton("remove_inputs", "Remove Inputs"),
    selectInput(
      "set_to_remove",
      "Select set to remove",
      choices = NULL
    )
  )
)

server <- function(input, output, session) {
  # define reactive values for key settings
  param_settings <- reactiveValues(
    sets_ids = c(),
    results = list()
  )

  # add dynamic UI set
  observeEvent(input$add_inputs, {
    new_ids <- stateInsertUI(
      dyn_UI,
      dyn_Server,
      session,
      selector = paste0('#', "add_inputs_here")
    )

    # update removal selection dropdown
    updateSelectInput(
      session,
      "set_to_remove",
      choices = new_ids
    )
  })

  # remove selected dynamic UI container
  observeEvent(input$remove_inputs, {
    req(input$set_to_remove)
    removeId <- input$set_to_remove
    new_ids <- stateRemoveUI(removeId, session)

    # update removal selection dropdown
    updateSelectInput(
      session,
      "set_to_remove",
      choices = new_ids
    )
  })

  # output is not refreshing, likely due to using session$userData
  output$values <- renderPrint({
    new_ids <- session$userData$sets_ids
    results <- session$userData$results
    purrr::walk(seq_along(new_ids), ~{
      print(results[[.x]]())
    })
  })
}

shinyApp(ui = ui, server = server)