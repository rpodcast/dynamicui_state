library(shiny)
library(R6)

ui <- fluidPage(
  h2("Dynamic UI Generation"),

  fluidRow(
    column(
      width = 12,
      tabsetPanel(
        id = "add_tabs_here",
      ),
      actionButton("add_tabs", "Add Tabs"),
      actionButton("remove_tabs", "Remove Tabs"),
      selectInput(
        "tab_to_remove",
        "Select tab to remove",
        choices = NULL
      )
    )
  ),

  fluidRow(
    column(
      width = 6,
      # placeholder for UI elements
      div(id = "add_inputs_here")
    ),
    column(
      width = 3,
      h4("Single Result View"),
      verbatimTextOutput("single_value")
    ),
    column(
      width = 3,
      h4("Multiple Results View"),
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
  last_id_tab <- reactiveVal(NULL)

  # class representing standalone UI insertion
  x <- DynamicClass$new(
    module_ui = dyn_UI,
    module_server = dyn_Server,
    selector = paste0('#', "add_inputs_here"),
    removal_input_id = "set_to_remove",
    session = session
  )

  # class representing tabset UI insertion
  x_tabs <- DynamicClass$new(
    module_ui = dyn_UI,
    module_server = dyn_Server,
    selector = "add_tabs_here",
    removal_input_id = "tab_to_remove",
    session = session,
    tabset = TRUE
  )

  # add dynamic UI set (tabset)
  observeEvent(input$add_tabs, {
    id <- x_tabs$insert()

    last_id_tab(id)
    # update selectInput
    updateSelectInput(
      session,
      "tab_to_remove",
      choices = x_tabs$all_ids()
    )
  })

  # add dynamic UI set (standalone)
  observeEvent(input$add_inputs, {
    id <- x$insert(display_id = TRUE)
    #last_id(tail(ids, n = 1))
    last_id(id)
    # update selectInput
    updateSelectInput(
      session,
      "set_to_remove",
      choices = x$all_ids()
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

  output$single_value <- renderPrint({
    req(last_id())
    lapply(x$results_obj(last_id()), function(obj) {
      print(obj())
    })
  })

  output$values <- renderPrint({
    lapply(x$results_obj(), function(obj) {
      print(obj())
    })
  })
}

shinyApp(ui = ui, server = server)