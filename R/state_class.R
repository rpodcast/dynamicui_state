DynamicClass <- R6::R6Class(
  "DynamicClass",
  private = list(
    module_ui = NULL,
    module_server = NULL,
    selector = NULL,
    removal_input_id = NULL,
    session = NULL,
    set_ids = NULL,
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
      private$set_ids <- c(private$set_ids, private$current_id)

      shiny::updateSelectInput(
        private$session,
        private$removal_input_id,
        choices = private$set_ids
      )

      invisible(self)
    },

    remove = function(removeId) {
      shiny::removeUI(
        selector = paste0("#", removeId),
        session = private$session
      )

      private$set_ids <- base::setdiff(private$set_ids, removeId)
      private$param_settings$results[[removeId]] <- NULL
      invisible(self)
    },

    results = function() {
      print(private$param_settings$results)
      invisible(self)
    }
  )
)
