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

More to come.

## Abstraction Attempt 2

More to come.
