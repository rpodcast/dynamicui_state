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
      uiOutput("last_id"),
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

  last_id <- reactiveVal(NULL)

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
    last_id(tail(ids, n = 1))
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
    last_id(tail(ids, n = 1))
    # update selectInput
    updateSelectInput(
      session,
      "set_to_remove",
      choices = ids
    )
  })

  output$last_id <- renderUI({
    req(last_id())
    p(glue::glue("The last ID entered is {last_id()}"))
  })

  output$values <- renderPrint({
    lapply(x$results_obj(), function(obj) {
      print(obj())
    })
  })
}

shinyApp(ui = ui, server = server)