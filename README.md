# 🧠 Projeto AP2 - Previsão de Desempenho Escolar com Shiny e Machine Learning

Este projeto tem como objetivo aplicar conceitos de **Estatística** e **Aprendizado de Máquina** na análise de desempenho estudantil, com base em dados públicos sobre notas de alunos. A aplicação permite prever, a partir de variáveis simples, se um estudante seria **Aprovado** ou **Reprovado**.

## 📊 Dataset Utilizado

Foi utilizado o dataset `students_cleaned.csv`, contendo informações de **1000 estudantes**, incluindo:

- Gênero
- Participação em curso preparatório
- Notas de Matemática, Leitura e Escrita

A variável-alvo (`aprovado`) foi criada com base na média geral das três disciplinas:

- **Aprovado:** média ≥ 60
- **Reprovado:** média < 60

---

## 🧪 Análises Estatísticas

Antes do modelo, diversas análises exploratórias foram feitas, incluindo:

- **Testes T** para comparar notas entre gêneros e participação em curso preparatório;
- **ANOVA** para grupos étnicos e nível de escolaridade dos pais;
- **Correlação entre as disciplinas**, mostrando forte associação entre leitura e escrita (ρ > 0.95).

---

## 🤖 Modelo de Machine Learning

O modelo utilizado foi um **Random Forest Classifier** (`ranger`) treinado com validação cruzada (5-fold) via `caret`, utilizando as seguintes variáveis:

- `nota_matematica`, `nota_leitura`, `nota_escrita`
- `genero`, `curso_preparatorio`

### Métricas Avaliadas:
- Acurácia
- Matriz de confusão
- Validação cruzada

---

## 💡 Aplicação Shiny

A aplicação interativa foi desenvolvida em **Shiny**, permitindo:

- O input de variáveis (notas, gênero, curso)
- A previsão em tempo real de **Aprovado/Reprovado**
- Facilidade de uso para educadores, pesquisadores e estudantes

### ✅ Acesse o App:

🔗 **[Clique aqui para acessar a aplicação Shiny](https://ml2025.shinyapps.io/ap2_ml_students/)**

---

## 📁 Estrutura do Projeto

```
📦ap2_ml_students
├── app.R                    # Aplicativo Shiny
├── modelo_rf.rds            # Modelo Random Forest treinado
├── students_cleaned.csv     # Base de dados em português
├── correlacoes_notas.csv    # Export com correlações entre notas
├── analise.R                # Script com testes estatísticos
├── README.md                # Este arquivo
```

---

## 🚀 Como Executar Localmente

1. Instale os pacotes necessários:

```r
install.packages(c("shiny", "caret", "ranger", "readr", "dplyr"))
```

2. Rode o app no RStudio:

```r
shiny::runApp("app.R")
```

---

## ✍️ Autores

- João Vitor Gouvea de Araujo
- Bruno Pilão
- Carol Cruz
- Maria da Graça Mello
- Mateus Norcia 
- [Adicione os demais integrantes do grupo, se houver]

---

## 📌 Observações

Este projeto foi desenvolvido como parte da **AP2 de Estatística e Machine Learning** do curso de Ciência de Dados, com foco em integração de modelos preditivos e visualizações interativas.
