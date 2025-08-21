#!/bin/bash

# Verificar que se pasó un argumento
if [ $# -lt 1 ]; then
    echo "Uso: $0 /ruta/a/dataset"
    exit 1
fi

DATASET_DIR="$1"
OUTPUT_DIR="output"

mkdir -p "$OUTPUT_DIR"

for subj in "$DATASET_DIR"/sub-*; do
    subj_id=$(basename "$subj")
    T1="${subj}/anat/${subj_id}_T1w.nii.gz"

    if [ -f "$T1" ]; then
        echo "Procesando $subj_id..."

        subj_out="${OUTPUT_DIR}/${subj_id}"
        mkdir -p "$subj_out"

        # Segmentación con FIRST
        run_first_all -i "$T1" -o "${subj_out}/${subj_id}_first"

        # Volumen total de regiones segmentadas
        fslstats "${subj_out}/${subj_id}_first-All_fast_firstseg.nii.gz" -V > "${subj_out}/volumen_total.txt"

        # Volumen por estructura
        for region in L_Hipp R_Hipp L_Thal R_Thal L_Caud R_Caud; do
            file="${subj_out}/${subj_id}_first-${region}.nii.gz"
            if [ -f "$file" ]; then
                vol=$(fslstats "$file" -V | awk '{print $2}')
                echo "${region}: ${vol} mm3" >> "${subj_out}/volumen_por_region.txt"
            fi
        done
    fi
done
