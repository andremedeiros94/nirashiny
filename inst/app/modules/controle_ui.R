mod_controleUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("paleta"), "Paleta de cores:",
      choices = c("viridis", "plasma", "inferno", "magma", "turbo", "Set1", "Dark2"),
      selected = "viridis")
  )
}