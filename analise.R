# ============================
# AP2 - Shiny com ML Real
# ============================

# ---- Pacotes ----
library(shiny)
library(readr)
library(dplyr)
library(caret)
library(ranger)

# ---- Leitura e Pré-processamento ----
df <- read_csv("students_cleaned.csv")

# Criar variável alvo a partir da média
df <- df %>%
  mutate(
    media = (nota_matematica + nota_leitura + nota_escrita)/3,
    aprovado = ifelse(media >= 60, "Aprovado", "Reprovado"),
    aprovado = as.factor(aprovado)
  )

# Remover notas da base para o modelo prever com base apenas nas variáveis socioeconômicas
df_modelo <- df %>%
  select(genero, grupo_etnico, educacao_pais, almoco, curso_preparatorio, aprovado)

# Garantir que são fatores
df_modelo <- df_modelo %>%
  mutate(across(everything(), as.factor))

# ---- Treinamento do modelo ----
set.seed(123)
modelo_rf <- train(
  aprovado ~ .,
  data = df_modelo,
  method = "ranger",
  trControl = trainControl(method = "cv", number = 5),
  preProcess = c("center", "scale")
)

# ---- Interface Shiny ----
ui <- fluidPage(
  titlePanel("Previsão de Aprovação de Aluno - MVP IA"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("genero", "Gênero:", choices = unique(df$genero)),
      selectInput("grupo_etnico", "Grupo Étnico:", choices = unique(df$grupo_etnico)),
      selectInput("educacao_pais", "Educação dos Pais:", choices = unique(df$educacao_pais)),
      selectInput("almoco", "Tipo de Almoço:", choices = unique(df$almoco)),
      selectInput("curso_preparatorio", "Curso Preparatório:", choices = unique(df$curso_preparatorio)),
      actionButton("prever", "Prever Aprovação", class = "btn-primary")
    ),
    
    mainPanel(
      h3("Resultado da Previsão:"),
      verbatimTextOutput("resultado")
    )
  )
)

# ---- Servidor Shiny ----
server <- function(input, output) {
  observeEvent(input$prever, {
    novo_aluno <- data.frame(
      genero = input$genero,
      grupo_etnico = input$grupo_etnico,
      educacao_pais = input$educacao_pais,
      almoco = input$almoco,
      curso_preparatorio = input$curso_preparatorio,
      stringsAsFactors = TRUE
    )
    
    # Corrigir níveis se necessário
    for (col in names(novo_aluno)) {
      novo_aluno[[col]] <- factor(novo_aluno[[col]], levels = levels(df_modelo[[col]]))
    }
    
    resultado <- predict(modelo_rf, newdata = novo_aluno)
    output$resultado <- renderText({ paste("✅ Previsão:", resultado) })
  })
}

# ---- Rodar App ----
shinyApp(ui = ui, server = server)
