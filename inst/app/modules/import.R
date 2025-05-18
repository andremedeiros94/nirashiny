mod_importUI <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(ns("arquivos"), "Selecione arquivos .csv", multiple = TRUE, accept = ".csv"),
    checkboxInput(ns("converter"), "Converter para reflectância (modo NIRA)", value = FALSE),
    actionButton(ns("processar"), "🚀 Processar Dados", class = "btn-success"),
    actionButton(ns("limpar"), "🗑️ Limpar Tudo", class = "btn-danger")
  )
}

mod_importServer <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$limpar, {
      dados(NULL)
      shinyjs::reset("arquivos")
      shinyjs::reset("converter")
    })

    observeEvent(input$processar, {
      req(input$arquivos)
      arquivos <- input$arquivos$datapath
      nomes <- input$arquivos$name

      lista <- lapply(arquivos, function(path) {
        espectro <- read.csv(path, header = FALSE)
        as.numeric(espectro[, 2])
      })

      df <- do.call(rbind, lista)
      colnames(df) <- read.csv(arquivos[1], header = FALSE)[, 1]

      if (isTRUE(input$converter)) {
        colnames(df) <- signif(10000000 / as.numeric(colnames(df)), 5)
      }

      rownames(df) <- nomes
      dados(as.data.frame(df))

      comp_ondas <- as.numeric(colnames(df))
      valores_todos <- unlist(df)

      updateNumericInput(session, "min_x", value = min(comp_ondas, na.rm = TRUE))
      updateNumericInput(session, "max_x", value = max(comp_ondas, na.rm = TRUE))
      updateNumericInput(session, "min_y", value = min(valores_todos, na.rm = TRUE))
      updateNumericInput(session, "max_y", value = max(valores_todos, na.rm = TRUE))
    })
  })
}