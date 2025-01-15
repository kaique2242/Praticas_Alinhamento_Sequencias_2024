#!/bin/bash

# Diretório contendo os arquivos .fastq
INPUT_DIR="./fastq_files"

# Diretório para os arquivos convertidos e limpos
OUTPUT_DIR="./cleaned_fasta"

# Certifique-se de que o diretório de saída existe
mkdir -p $OUTPUT_DIR

# Processamento de cada arquivo usando um loop
for file in $INPUT_DIR/*.fastq; do
  # Obtem o nome do arquivo sem extensão
  base_name=$(basename "$file" .fastq)
  
  echo "Processando $base_name..."
  
  # Limpeza e corte de sequências de baixa qualidade com Trim Galore
  trim_galore --fastqc -q 25 --trim-n --max_n 0 -j 1 --length 18 --dont_gzip "$file" -o "$OUTPUT_DIR"
  
  # Obtem o nome do arquivo limpo gerado pelo Trim Galore (supondo que ele adiciona "_trimmed" ao nome)
  trimmed_file="${OUTPUT_DIR}/${base_name}_trimmed.fq"
  
  # Converter .fastq (limpo) para .fasta usando seqtk
  seqtk seq -a "$trimmed_file" > "$OUTPUT_DIR/${base_name}.fasta"
  
  echo "$base_name processado e convertido com sucesso!"
done

echo "Todos os arquivos foram processados e convertidos."
