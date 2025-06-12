# ============================
# AP2 - Estatística e Machine Learning com StudentsPerformance
# ============================

# ---- Pacotes ----
pacotes <- c("dplyr", "ggplot2", "ggpubr", "nortest", "readr", "tidyr")
instalar <- pacotes[!(pacotes %in% installed.packages())]
if(length(instalar)) install.packages(instalar)

library(dplyr)
library(ggplot2)
library(ggpubr)
library(nortest)
library(readr)
library(tidyr)

# ---- Leitura e Pré-processamento ----
df <- read_csv("StudentsPerformance.csv")

colnames(df) <- c("genero", "grupo_etnico", "educacao_pais", "almoco", "curso_preparatorio",
                  "nota_matematica", "nota_leitura", "nota_escrita")

cat("Dataset possui", nrow(df), "linhas e", ncol(df), "colunas.\n")
summary(df)

# ---- Visualizações ----
g1 <- ggplot(df, aes(x = genero, y = nota_matematica, fill = genero)) +
  geom_boxplot() + theme_minimal() + ggtitle("Notas de Matemática por Gênero")

g2 <- ggplot(df, aes(x = curso_preparatorio, y = nota_matematica, fill = curso_preparatorio)) +
  geom_boxplot() + theme_minimal() + ggtitle("Notas por Curso Preparatório")

g3 <- ggplot(df, aes(x = grupo_etnico, y = nota_matematica, fill = grupo_etnico)) +
  geom_boxplot() + theme_minimal() + ggtitle("Notas por Grupo Étnico")

g4 <- ggplot(df, aes(x = educacao_pais, y = nota_matematica, fill = educacao_pais)) +
  geom_boxplot() + theme_minimal() + ggtitle("Notas por Nível de Educação dos Pais") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Novos gráficos:
g5 <- ggplot(df, aes(x = genero, y = nota_leitura, fill = genero)) +
  geom_boxplot() + theme_minimal() + ggtitle("Notas de Leitura por Gênero")

g6 <- ggplot(df, aes(x = genero, y = nota_escrita, fill = genero)) +
  geom_boxplot() + theme_minimal() + ggtitle("Notas de Escrita por Gênero")

print(g1); print(g2); print(g3); print(g4); print(g5); print(g6)

# ---- Testes Estatísticos ----

# Gênero vs Notas
teste_t_genero_matematica <- t.test(nota_matematica ~ genero, data = df)
teste_t_genero_leitura    <- t.test(nota_leitura ~ genero, data = df)
teste_t_genero_escrita    <- t.test(nota_escrita ~ genero, data = df)

# Curso preparatório
teste_t_curso <- t.test(nota_matematica ~ curso_preparatorio, data = df)

# ANOVA Grupo Étnico
teste_anova_grupo <- aov(nota_matematica ~ grupo_etnico, data = df)
# Post-hoc
if(summary(teste_anova_grupo)[[1]]$`Pr(>F)`[1] < 0.05) {
  cat("\nPost-hoc Tukey para grupo étnico:\n")
  print(TukeyHSD(teste_anova_grupo))
}

# ANOVA Educação dos Pais
teste_anova_educacao <- aov(nota_matematica ~ educacao_pais, data = df)
# Post-hoc
if(summary(teste_anova_educacao)[[1]]$`Pr(>F)`[1] < 0.05) {
  cat("\nPost-hoc Tukey para nível de educação dos pais:\n")
  print(TukeyHSD(teste_anova_educacao))
}

# Teste de normalidade
print(lillie.test(df$nota_matematica))

# ---- Correlação entre Notas ----
correlacoes <- df %>%
  select(nota_matematica, nota_leitura, nota_escrita) %>%
  cor()
print(correlacoes)

# ---- Exportação para o Artigo ----
write.csv(correlacoes, "correlacoes_notas.csv", row.names = TRUE)
write.csv(df, "students_cleaned.csv", row.names = FALSE)

# ---- Conclusões Parciais ----
cat("\n🔎 Conclusões:\n")
cat("- Diferença significativa em matemática entre gêneros (p <", round(teste_t_genero_matematica$p.value, 4), ")\n")
cat("- Diferença significativa em leitura entre gêneros (p <", round(teste_t_genero_leitura$p.value, 4), ")\n")
cat("- Diferença significativa em escrita entre gêneros (p <", round(teste_t_genero_escrita$p.value, 4), ")\n")
cat("- Curso preparatório melhora desempenho (p <", round(teste_t_curso$p.value, 4), ")\n")
cat("- Grupo étnico influencia as notas (ANOVA p <", round(summary(teste_anova_grupo)[[1]]$`Pr(>F)`[1], 4), ")\n")
cat("- Educação dos pais também influencia significativamente (ANOVA p <", round(summary(teste_anova_educacao)[[1]]$`Pr(>F)`[1], 4), ")\n")
cat("- Notas possuem alta correlação entre si\n")
