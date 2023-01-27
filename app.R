library(shiny)
library(R6)

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
  x <- DynamicClass$new(
    module_ui = dyn_UI,
    module_server = dyn_Server,
    selector = paste0('#', "add_inputs_here"),
    removal_input_id = "set_to_remove",
    session = session
  )

  # add dynamic UI set
  observeEvent(input$add_inputs, {
    ids <- x$insert()

    # update selectInput
    updateSelectInput(
      session,
      "set_to_remove",
      choices = ids
    )
  })

  # remove selected dynamic UI container
  observeEvent(input$remove_inputs, {
    req(input$set_to_remove)
    removeId <- input$set_to_remove
    ids <- x$remove(removeId)

    # update selectInput
    updateSelectInput(
      session,
      "set_to_remove",
      choices = ids
    )
  })

  # output is not refreshing, likely due to using session$userData
  output$values <- renderPrint({
    lapply(x$results_obj(), function(obj) {
      print(obj())
    })
  })
}

shinyApp(ui = ui, server = server)