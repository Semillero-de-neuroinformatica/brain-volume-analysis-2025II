#!/bin/bash

export FSLPARALLEL="" # Desactivar paralelismo en FSL

BRAINS_DIR="./brains"
FIRST_DIR="./first"
mkdir -p $FIRST_DIR

SKIP_SUBJS=("sub-09" "sub-11" "sub-12" "sub-17" "sub-18" "sub-20")  # IDs de sujetos a excluir

for BRAIN_FILE in ${BRAINS_DIR}/sub-*T1w_brain.nii.gz; do
    SUBJ=$(basename $BRAIN_FILE _T1w_brain.nii.gz)
    
    # Verificar si el sujeto está en la lista de exclusión
    if [[ " ${SKIP_SUBJS[@]} " =~ " ${SUBJ} " ]]; then
        echo "🚫 $SUBJ está en la lista de exclusión, saltando"
        continue
    fi

    echo "=== Ejecutando FIRST: $SUBJ ==="
    OUT_PREFIX="${FIRST_DIR}/${SUBJ}_first"

    # Verificar si ya fue procesado usando comodín
    if ls "${OUT_PREFIX}"*"-L_Hipp_first"* 1> /dev/null 2>&1; then
        echo "⏭️ $SUBJ ya procesado con FIRST, saltando"
        continue
    fi

    # Ejecuta FIRST
    run_first_all -i $BRAIN_FILE -o $OUT_PREFIX \
      -s L_Hipp,R_Hipp,L_Thal,R_Thal,L_Caud,R_Caud,L_Puta,R_Puta,L_Pall,R_Pall,L_Amyg,R_Amyg,BrStem

    echo "✅ FIRST completado para $SUBJ"
done

echo "🎉 Todos los sujetos procesados con FIRST"
