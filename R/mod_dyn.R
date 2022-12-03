dyn_UI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      h4(paste("container", id)),
      column(
        width = 4,
        selectInput(
          ns("type"),
          "Type",
          choices = c(
            "Alpha" = "alpha",
            "Beta" = "beta",
            "Gamma" = "gamma"
          ),
          selected = "alpha"
        )
      ),
      column(
        width = 4,
        checkboxGroupInput(
          ns("methods"),
          "Choose Method",
          choices = c(
            "Frequentist" = "freq",
            "Bayesian" = "bayes",
            "Machine Learning" = "ml"
          )
        )
      )
    )
  )
}

dyn_Server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      # assemble input values into a reactive list
      res <- reactive({
        list(
          type = input$type,
          methods = input$methods
        )
      })

      return(res)
    }
  )
}