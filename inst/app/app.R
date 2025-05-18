library(shiny)
library(bs4Dash)
library(shinyjs)
library(viridis)
library(openxlsx)
library(devtools)
library(ggplot2)

# Carrega os módulos
source("modules/import.R")
source("modules/graficos.R")
source("modules/tabela_preview.R")
source("modules/controle_ui.R")

# UI principal
ui <- bs4DashPage(
  title = "NIRA Modular",
  
  header = bs4DashNavbar(title = "🧪 NIRA Modular"),
  
  sidebar = bs4DashSidebar(
    skin = "dark",
    status = "primary",
    bs4SidebarMenu(
      bs4SidebarMenuItem("Início", tabName = "inicio", icon = icon("home")),
      bs4SidebarMenuItem("Pré-processamento", tabName = "preprocessamento", icon = icon("sliders-h")),
      bs4SidebarMenuItem("Modelagem", tabName = "modelagem", icon = icon("cogs"))
    )
  ),
  
  body = bs4DashBody(
    useShinyjs(),
    bs4TabItems(
      
      # Aba Início
      bs4TabItem(tabName = "inicio",
                 fluidRow(
                   bs4Card(title = "Importação", width = 6, mod_importUI("importador")),
                   bs4Card(title = "Exportar", width = 6, downloadButton("exportar", "⬇️ Baixar .xlsx"))
                 ),
                 
                 fluidRow(
                   bs4Card(title = "Paleta de Cores", width = 2, mod_controleUI("controle"),
                           br(),
                           p("Selecione uma paleta para personalizar a visualização dos espectros."),
                           br()),
                   bs4Card(title = "Dados Brutos", width = 5, plotOutput("graficos-plot_raw")),
                   bs4Card(title = "Média dos Espectros", width = 5, plotOutput("graficos-plot_mean"))
                 ),
                 fluidRow(
                   bs4Card(title = "Preview", width = 12, mod_tabelaPreviewUI("tabela"))
                 )
      ),
      
      # Aba Pré-processamento (placeholder)
      bs4TabItem(tabName = "preprocessamento",
                 fluidRow(
                   bs4Card(title = "Pré-processamento", width = 12,
                           p("Esta seção será usada para aplicar transformações como SNV, MSC, derivadas, etc.")
                   )
                 )
      ),
      
      # Aba Modelagem (placeholder)
      bs4TabItem(tabName = "modelagem",
                 fluidRow(
                   bs4Card(title = "Modelagem", width = 12,
                           p("Esta seção será usada para criar, ajustar e validar modelos de machine learning.")
                   )
                 )
      )
    )
  )
)

# Server principal
server <- function(input, output, session) {
  dados <- reactiveVal(NULL)
  
  # Módulo de importação
  mod_importServer("importador", dados = dados)
  
  # Módulo de gráficos
  mod_graficosServer("graficos", dados = dados, paleta = reactive(input[["controle-paleta"]]))
  
  # Módulo de preview da tabela
  mod_tabelaPreviewServer("tabela", dados = dados)
  
  # Exportação dos dados processados
  output$exportar <- downloadHandler(
    filename = function() paste0("dados_nir_", Sys.Date(), ".xlsx"),
    content = function(file) write.xlsx(dados(), file, rowNames = TRUE)
  )
}

# Inicializa o app
shinyApp(ui, server)
