# Development Journal

## MVP Version

A version of the dynamic UI state management adapted from a real-world situation is available at commit [1aa61c](https://github.com/rpodcast/dynamicui_state/blob/1aa61c5ee0511d47db03c111c5295920abda2ad9/app.R). While the app certainly works, the book-keeping required to track the state of the dynamic UI is quite involved:

* Establish [reactive values](https://shiny.rstudio.com/reference/shiny/1.7.3/reactivevalues) for recording random IDs assigned to each dynamic input container and a list of each container's input values
* Create a random ID before inserting a dynamic UI container
* Record a reactive of the container input values into the appropriate reactive values results slot
* Update a select input that lets the user choose which dynamic container to remove
* When removing a dynamic input container:
    + Assign the results slot for the selected ID to null
    + Remove the selected ID from the IDs slot of thereactive values

## Abstraction Attempt 1

Application code available in commit [1c0c74](https://github.com/rpodcast/dynamicui_state/tree/1c0c74e65aefc11293e085cd9d3bc5e9edff6269). 

Instead of making the user establish reactive values themselves, I created two wrapper functions called [`stateInsertUI`](https://github.com/rpodcast/dynamicui_state/blob/1c0c74e65aefc11293e085cd9d3bc5e9edff6269/R/state_utils.R#L1-L44) and [`stateRemoveUI`](https://github.com/rpodcast/dynamicui_state/blob/1c0c74e65aefc11293e085cd9d3bc5e9edff6269/R/state_utils.R#L46-L63) that leverage the [`session$userData`](https://shiny.rstudio.com/reference/shiny/1.7.3/session.html) environment slot to keep the random IDs and input results pertaining to each dynamic input container. This is a mild improvement, but still has a few areas for improvement:

* When we add reactive results to `session$userData`, any downstream reactives or outputs do not refresh correctly after an update, which basically defeats the purpose of using this slot. However, adding the random IDs of each dynamic input container seems to work well.
* The user is still expected to create a select-like input to serve up the choices of dynamic input containers to remove. I hope we can have an auto-generated input instead.
 

## Abstraction Attempt 2

More to come.
