#!/bin/bash

# === Directorios ===
BRAINS_DIR="./brains"
FAST_DIR="./fast"
mkdir -p $FAST_DIR

for BRAIN_FILE in ${BRAINS_DIR}/sub-*T1w_brain.nii.gz; do
    SUBJ=$(basename $BRAIN_FILE _T1w_brain.nii.gz)
    echo "=== Segmentando con FAST: $SUBJ ==="

    OUT_PREFIX="${FAST_DIR}/${SUBJ}_fast"

    if [[ -f "${OUT_PREFIX}_seg.nii.gz" ]]; then
        echo "⏭️ $SUBJ ya procesado con FAST, saltando (archivo existe: ${OUT_PREFIX}_seg.nii.gz)"
    else
        # FAST: FMRIB's Automated Segmentation Tool
        # Qué hace fast: segmenta en 3 tejidos (GM, WM, CSF) 
        # -t 1: define el tipo de imagen (1 = T1)
        # -n 3: número de tejidos a segmentar (3 = GM, WM, CSF)
        # -H 0.1: suavizado (0.1 es un valor común)
        # -I 4: número de iteraciones del algoritmo de segmentación (4 es un valor común)
        # -l 20.0: umbral para eliminar pequeños componentes (20.0 es un valor común)
        fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -o $OUT_PREFIX $BRAIN_FILE

        echo ">>> Segmentación de $SUBJ guardada en $FAST_DIR"
    fi
done

echo "✅ Todos los sujetos segmentados con FAST"
