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
    new_id <- stringi::stri_rand_strings(1, 6)
    param_settings$sets_ids <- c(
      param_settings$sets_ids, 
      new_id
    )

    insertUI(
      selector = paste0('#', "add_inputs_here"),
      ui = tagList(
        div(
          id = new_id,
          dyn_UI(new_id)
        )
      )
    )

    # update removal selection dropdown
    updateSelectInput(
      session,
      "set_to_remove",
      choices = param_settings$sets_ids
    )

    # execute server-side portion of param module
    param_settings$results[[new_id]] <- dyn_Server(new_id)
  })

  # remove selected dynamic UI container
  observeEvent(input$remove_inputs, {
    req(input$set_to_remove)
    remove_id <- input$set_to_remove

    removeUI(
      selector = paste0("#", remove_id)
    )

    # update reactive values
    param_settings$results[[remove_id]] <- NULL
    param_settings$sets_ids <- base::setdiff(param_settings$sets_ids, remove_id)

    # update removal selection dropdown
    updateSelectInput(
      session,
      "set_to_remove",
      choices = param_settings$sets_ids
    )

  })

  output$values <- renderPrint({
    req(param_settings$sets_ids)
    purrr::walk(seq_along(param_settings$sets_ids), ~{
      print(param_settings$results[[.x]]())
    })
  })
}

shinyApp(ui = ui, server = server)