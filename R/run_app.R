#' Inicia o aplicativo NIRA Shiny
#'
#' Esta função inicia o aplicativo Shiny localizado na pasta inst/app do pacote.
#'
#' @return Executa o aplicativo Shiny
#' @export
run_app <- function() {
  shiny::runApp(system.file("app", package = "nirashiny"))
}