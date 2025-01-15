# Lista de pacotes necessários
required_packages <- c("dplyr", "reshape2", "ComplexHeatmap", "viridis")

# Função para instalar pacotes ausentes
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}

# Instalar pacotes ausentes
invisible(lapply(required_packages, install_if_missing))

# Carregar os pacotes
library(dplyr)
library(reshape2)
library(ComplexHeatmap)
library(viridis)


counts_bowtie_av0 <- read.csv("C:\\Users\\victo\\Downloads\\counts_bowtie_av0.csv")
metadados_wolb    <- read.csv("C:\\Users\\victo\\Downloads\\metadados_wolb.csv")
wolbs             <- read.csv("C:\\Users\\victo\\Downloads\\cepas_de_wolbachia.csv")

counts_av0 <- inner_join(counts_bowtie_av0, metadados_wolb, by = "library")
head(counts_av0)

counts_av0 <- counts_av0 %>%
  mutate(RPM = (read_counts / lib_size) * 1e6)

counts_av0$corrected <- sub("NZ_", "", counts_av0$cepa)
counts_av0 <- inner_join(counts_av0, wolbs, by = c("corrected"="AccessionVersion"))

d_counts_av0 <- dcast(counts_av0, library + tratamento_tetraciclina ~ corrected + Title_reduced, value.var = "RPM")

# Converter em matriz numérica, removendo as colunas de texto
d_counts_av0_matrix <- as.matrix(d_counts_av0[, c(-1, -2)])

# Ajustar nomes de linha para incorporar informação de tratamento
row.names(d_counts_av0_matrix) <- paste0(d_counts_av0[, 1], "_", d_counts_av0[, 2])

Heatmap(d_counts_av0_matrix,
        name = "RPM",                                 # Nome da escala
        row_title = "Bibliotecas de Pequenos RNAs",    # Título para linhas
        row_title_gp = gpar(fontsize = 14, fontface = "bold"),
        row_dend_side = "left",
        row_names_side = "left",
        row_names_gp = gpar(fontsize = 10),
        column_title = "Cepas de Wolbachia",           # Título para colunas
        column_title_gp = gpar(fontsize = 10, fontface = "bold"),
        column_names_gp = gpar(fontsize = 6),
        col = viridis(100)                             # Paleta de cores
)

# Converter a variável para fator, se ainda não for
counts_av0$tratamento_tetraciclina <- as.factor(counts_av0$tratamento_tetraciclina)

# Realizar o teste ANOVA
anova_result <- aov(RPM ~ tratamento_tetraciclina, data = counts_av0)

# Resumo do resultado ANOVA
anova_summary <- summary(anova_result)
anova_summary


