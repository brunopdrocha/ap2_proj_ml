library(shiny)
library(caret)

# Carrega o modelo treinado
modelo_rf <- readRDS("modelo_rf.rds")

# Interface
ui <- fluidPage(
  titlePanel("Previsão de Aprovação Escolar (MVP)"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("nota_matematica", "Nota de Matemática:", value = 60, min = 0, max = 100),
      numericInput("nota_leitura", "Nota de Leitura:", value = 60, min = 0, max = 100),
      numericInput("nota_escrita", "Nota de Escrita:", value = 60, min = 0, max = 100),
      selectInput("genero", "Gênero:",
                  choices = levels(modelo_rf$trainingData$genero)),
      selectInput("curso_preparatorio", "Curso Preparatório:",
                  choices = levels(modelo_rf$trainingData$curso_preparatorio)),
      actionButton("predict", "Rodar Previsão")
    ),
    
    mainPanel(
      h3("Resultado:"),
      verbatimTextOutput("resultado")
    )
  )
)

# Servidor
server <- function(input, output) {
  observeEvent(input$predict, {
    # ⚠️ Criar exatamente as colunas esperadas pelo modelo, com os mesmos tipos e nomes
    novo_dado <- modelo_rf$trainingData[0, -1]  # Cria estrutura com as colunas certas
    novo_dado[1, ] <- NA  # adiciona uma linha em branco
    
    novo_dado$nota_matematica <- as.numeric(input$nota_matematica)
    novo_dado$nota_leitura <- as.numeric(input$nota_leitura)
    novo_dado$nota_escrita <- as.numeric(input$nota_escrita)
    novo_dado$genero <- factor(input$genero, levels = levels(modelo_rf$trainingData$genero))
    novo_dado$curso_preparatorio <- factor(input$curso_preparatorio,
                                           levels = levels(modelo_rf$trainingData$curso_preparatorio))
    
    # Faz a previsão
    predicao <- predict(modelo_rf, newdata = novo_dado)
    prob <- predict(modelo_rf, newdata = novo_dado, type = "prob")[, "Aprovado"]
    
    output$resultado <- renderPrint({
      cat("Previsão:", as.character(predicao), "\n")
      cat("Probabilidade de Aprovação:", round(prob * 100, 2), "%")
    })
  })
}

# Roda o app
shinyApp(ui = ui, server = server)
