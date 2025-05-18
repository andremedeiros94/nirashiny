mod_graficosServer <- function(id, dados, paleta) {
  moduleServer(id, function(input, output, session) {
    
    output$plot_raw <- renderPlot({
      req(dados())
      req(paleta())
      
      df_long <- as.data.frame(dados())
      df_long$Amostra <- factor(rownames(df_long))
      
      df_long <- tidyr::pivot_longer(df_long, cols = -Amostra, names_to = "Comprimento", values_to = "Valor")
      df_long$Comprimento <- suppressWarnings(as.numeric(df_long$Comprimento))
      df_long <- df_long[!is.na(df_long$Comprimento), ]
      
      ggplot2::ggplot(df_long, ggplot2::aes(x = Comprimento, y = Valor, color = Amostra)) +
        ggplot2::geom_line(size = 0.6) +
        ggplot2::scale_color_viridis_d(option = paleta()) +
        ggplot2::theme_minimal() +
        ggplot2::labs(title = "Dados Brutos", x = "Comprimento de onda", y = "Absorbância / Reflectância")
    })
    
    output$plot_mean <- renderPlot({
      req(dados())
      req(paleta())
      
      df_long <- as.data.frame(dados())
      df_long$Amostra <- rownames(df_long)
      df_long <- tidyr::pivot_longer(df_long, cols = -Amostra, names_to = "Comprimento", values_to = "Valor")
      df_long$Comprimento <- suppressWarnings(as.numeric(df_long$Comprimento))
      df_long <- df_long[!is.na(df_long$Comprimento), ]
      
      df_summary <- dplyr::group_by(df_long, Comprimento) |>
        dplyr::summarise(Media = mean(Valor), .groups = "drop")
      
      ggplot2::ggplot(df_summary, ggplot2::aes(x = Comprimento, y = Media, color = "Média")) +
        ggplot2::geom_line(size = 0.9) +
        ggplot2::scale_color_viridis_d(option = paleta()) +
        ggplot2::theme_minimal() +
        ggplot2::labs(title = "Média dos Espectros", x = "Comprimento de onda", y = "Média da Reflectância / Absorbância") +
        ggplot2::guides(color = "none")  # oculta legenda desnecessária (opcional)
    })
  })
}