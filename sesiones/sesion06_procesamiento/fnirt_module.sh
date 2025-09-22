#!/bin/bash

export FSLPARALLEL="" # Desactivar paralelismo en FSL

BRAINS_DIR="./brains"
FLIRT_DIR="./flirt"
FNIRT_DIR="./fnirt"
ATLAS="./atlas/nihpd_sym_10.0-14.0_t1w_masked.nii" 
mkdir -p $FNIRT_DIR


for FLIRT_FILE in ${FLIRT_DIR}/sub-*flirt.nii.gz; do
    SUBJ=$(basename $FLIRT_FILE _flirt.nii.gz)

    echo "=== Ejecutando FNIRT: $SUBJ ==="

    # Archivos de entrada
    BRAIN_FILE="${BRAINS_DIR}/${SUBJ}_T1w_brain.nii.gz"
    AFFINE_MAT="${FLIRT_DIR}/${SUBJ}_flirt.mat"

    # Archivos de salida
    COEFF_OUT="${FNIRT_DIR}/${SUBJ}_fnirt_coeff.nii.gz"
    WARPED_OUT="${FNIRT_DIR}/${SUBJ}_fnirt.nii.gz"

    # Verificar si ya fue procesado
    if [[ -f "$COEFF_OUT" && -f "$WARPED_OUT" ]]; then
        echo "⏭️ $SUBJ ya procesado con FNIRT, saltando"
        continue
    fi

    # Ejecuta FNIRT
    fnirt --in=$BRAIN_FILE \
          --aff=$AFFINE_MAT \
          --ref=$ATLAS \
          --cout=$COEFF_OUT \
          --iout=$WARPED_OUT

    echo "✅ FNIRT completado para $SUBJ"
done

echo "🎉 Todos los sujetos procesados con FNIRT"
