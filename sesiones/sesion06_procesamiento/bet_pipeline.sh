#!/bin/bash

# Carpeta del dataset
DATASET_DIR="../../dataset"

# Carpeta donde guardar los cerebros
OUT_DIR="./brains"
mkdir -p $OUT_DIR

# Recorrer todos los sujetos dentro del dataset
for SUBJ_DIR in ${DATASET_DIR}/sub-*; do
    SUBJ=$(basename $SUBJ_DIR)  # sub-01, sub-02...
    echo "=== Procesando $SUBJ ==="

    # Archivo T1 dentro de anat
    T1_FILE="${SUBJ_DIR}/anat/${SUBJ}_T1w.nii.gz"

    if [[ -f "$T1_FILE" ]]; then
        echo "Usando archivo: $T1_FILE"

        # Salida en carpeta brains
        OUT_FILE="${OUT_DIR}/${SUBJ}_T1w_brain.nii.gz"

        # Verificar si el archivo de salida ya existe
        if [[ -f "$OUT_FILE" ]]; then
            echo "⏭️ $SUBJ ya procesado, saltando (archivo existe: $OUT_FILE)"
        else
            # BET: Brain Extraction Tool
            # Qué hace bet: extrae el cerebro de la imagen T1
            # -f 0.4: umbral de fracción de intensidad (0.4 es un valor común)
            # -g 0: desplazamiento vertical del umbral (0 es un valor común)
            # -R: modo robusto (útil para imágenes con mucha variabilidad)
            bet "$T1_FILE" "$OUT_FILE" -f 0.4 -g 0 -R

            echo ">>> $SUBJ procesado, cerebro guardado en $OUT_FILE"
        fi
    else
        echo "⚠️ No se encontró el archivo T1 para $SUBJ"
    fi
done

echo "✅ Todos los cerebros extraídos con BET"
