DynamicClass <- R6::R6Class(
  "DynamicClass",
  private = list(
    module_ui = NULL,
    module_server = NULL,
    selector = NULL,
    removal_input_id = NULL,
    session = NULL,
    ids = NULL,
    current_id = NULL,
    param_settings = NULL
  ),
  public = list(
    initialize = function(
      module_ui = NULL,
      module_server = NULL,
      selector = NULL,
      removal_input_id = NULL,
      session = shiny::getDefaultReactiveDomain()
    ) {

      if (is.null(session)) {
        stop("DynamicClass objects need to be initialized within a Shiny or module server function", call. = FALSE)
      }

      private$session <- session
      private$module_ui <- module_ui
      private$module_server <- module_server
      private$selector <- selector
      private$removal_input_id <- removal_input_id
      private$param_settings <- shiny::reactiveValues(
        results = list()
      )
    },
    insert = function() {
      private$current_id <- stringi::stri_rand_strings(1, 6)
      
      ui <- htmltools::tagList(
        htmltools::div(
          id = private$current_id,
          private$module_ui(private$current_id)
        )
      )

      shiny::insertUI(
        ui = ui,
        selector = private$selector,
        session = private$session
      )

      res <- private$module_server(private$current_id)

      private$param_settings$results[[private$current_id]] <- res
      private$ids <- c(private$ids, private$current_id)

      return(private$ids)
    },

    remove = function(removeId) {
      shiny::removeUI(
        selector = paste0("#", removeId),
        session = private$session
      )

      private$ids <- base::setdiff(private$ids, removeId)
      private$param_settings$results[[removeId]] <- NULL
      return(private$ids)
    },

    results = function() {
      print(private$param_settings$results)
      invisible(self)
    }
  )
)
