#!/bin/bash

export FSLPARALLEL="" # Desactivar paralelismo en FSL

BRAINS_DIR="./brains"
FLIRT_DIR="./flirt"
ATLAS="./atlas/nihpd_sym_10.0-14.0_t1w_masked.nii" 
mkdir -p $FLIRT_DIR

# Sujetos a excluir
SKIP_SUBJS=("")

for BRAIN_FILE in ${BRAINS_DIR}/sub-*T1w_brain.nii.gz; do
    SUBJ=$(basename $BRAIN_FILE _T1w_brain.nii.gz)

    # Verificar si el sujeto está en la lista de exclusión
    if [[ " ${SKIP_SUBJS[@]} " =~ " ${SUBJ} " ]]; then
        echo "🚫 $SUBJ está en la lista de exclusión, saltando"
        continue
    fi

    echo "=== Ejecutando FLIRT: $SUBJ ==="
    OUT_PREFIX="${FLIRT_DIR}/${SUBJ}_flirt"

    # Verificar si ya fue procesado
    if [[ -f "${OUT_PREFIX}.nii.gz" && -f "${OUT_PREFIX}.mat" ]]; then
        echo "⏭️ $SUBJ ya procesado con FLIRT, saltando"
        continue
    fi

    # Ejecuta FLIRT
    flirt -in $BRAIN_FILE \
          -ref $ATLAS \
          -out ${OUT_PREFIX}.nii.gz \
          -omat ${OUT_PREFIX}.mat \
          -bins 256 -cost corratio \
          -searchrx -90 90 -searchry -90 90 -searchrz -90 90 \
          -dof 12 -interp trilinear

    echo "✅ FLIRT completado para $SUBJ"
done

echo "🎉 Todos los sujetos procesados con FLIRT"
