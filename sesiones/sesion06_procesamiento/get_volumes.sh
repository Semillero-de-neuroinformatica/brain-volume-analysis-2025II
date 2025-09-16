#!/bin/bash

# Carpeta de salida
OUT_DIR="./subcortical_volumes"
mkdir -p $OUT_DIR

OUT_CSV="${OUT_DIR}/volumenes_first.csv"
FIRST_DIR="./first"

# Diccionario: Label → Nombre
declare -A LABELS
LABELS[10]="L_Thal"
LABELS[11]="L_Caud"
LABELS[12]="L_Puta"
LABELS[13]="L_Pall"
LABELS[16]="BrStem"
LABELS[17]="L_Hipp"
LABELS[18]="L_Amyg"
LABELS[49]="R_Thal"
LABELS[50]="R_Caud"
LABELS[51]="R_Puta"
LABELS[52]="R_Pall"
LABELS[53]="R_Hipp"
LABELS[54]="R_Amyg"

# Cabecera del CSV
echo "Subject,Structure,Label,NumVoxels,Volume_mm3" > $OUT_CSV

for FILE in ${FIRST_DIR}/sub-*origsegs.nii.gz; do
    SUBJ=$(basename $FILE _first_all_fast_origsegs.nii.gz)
    echo "=== Procesando $SUBJ ==="
    
    for LABEL in 10 11 12 13 16 17 18 49 50 51 52 53 54; do
        RES=$(fslstats $FILE -l $(echo "$LABEL-0.5" | bc) -u $(echo "$LABEL+0.5" | bc) -V)
        NUM=$(echo $RES | awk '{print $1}')
        VOL=$(echo $RES | awk '{print $2}')
        
        echo "${SUBJ},${LABELS[$LABEL]},${LABEL},${NUM},${VOL}" >> $OUT_CSV
    done
done

echo "✅ Volúmenes exportados en $OUT_CSV"
