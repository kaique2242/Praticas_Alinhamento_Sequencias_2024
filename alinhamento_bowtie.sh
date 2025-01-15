 #!/bin/bash

# Diretório contendo os arquivos .fastq
INPUT_DIR="./fastq_files"

# Diretório para armazenar os arquivos de saída
OUTPUT_DIR="./aligned_sam"

# Nome do índice de referência (assumindo que já foi criado previamente)
REFERENCE_INDEX="reference_index"

# Certifique-se de que o diretório de saída existe
mkdir -p $OUTPUT_DIR

# Alinhamento de cada arquivo usando um loop
for file in $INPUT_DIR/*.fastq; do
  # Obtem o nome do arquivo sem extensão
  base_name=$(basename "$file" .fastq)
  
  echo "Alinhando $base_name..."
  
  # Alinha as sequências usando o Bowtie
  bowtie -f -S -a -v 0 -p 3 -t $REFERENCE_INDEX "$file" > "$OUTPUT_DIR/${base_name}.sam" 2> "$OUTPUT_DIR/${base_name}_bowtie.log"
  
  echo "$base_name alinhado com sucesso!"
done

echo "Todos os arquivos foram alinhados."
