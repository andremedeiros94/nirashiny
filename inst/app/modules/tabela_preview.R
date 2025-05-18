mod_tabelaPreviewUI <- function(id) {
  ns <- NS(id)
  tagList(
    numericInput(ns("n_linhas"), "Número de linhas:", value = 20, min = 1, max = 100),
    numericInput(ns("n_colunas"), "Número de colunas:", value = 10, min = 1, max = 500),
    verbatimTextOutput(ns("preview"))
  )
}

mod_tabelaPreviewServer <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    output$preview <- renderPrint({
      df <- dados()
      req(df)
      cat(paste0("Mostrando as primeiras ", input$n_linhas, " linhas e ", input$n_colunas, " colunas:\n\n"))
      print(head(df[, 1:min(input$n_colunas, ncol(df)), drop = FALSE], n = input$n_linhas))
    })
  })
}