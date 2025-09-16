#!/bin/bash

FAST_DIR="./fast"
ICV_DIR="./icv"
mkdir -p $ICV_DIR

OUT_FILE="${ICV_DIR}/volumes_results.tsv"
echo -e "Subject\tGM_mm3\tWM_mm3\tCSF_mm3\tICV_mm3\tGM_norm\tWM_norm\tCSF_norm" > $OUT_FILE

for SUBJ in $(ls ${FAST_DIR}/*_fast_pve_0.nii.gz | sed 's/_fast_pve_0.nii.gz//' | xargs -n1 basename); do
    CSF="${FAST_DIR}/${SUBJ}_fast_pve_0.nii.gz" # Liquido cefalorraquídeo
    GM="${FAST_DIR}/${SUBJ}_fast_pve_1.nii.gz" # Materia gris
    WM="${FAST_DIR}/${SUBJ}_fast_pve_2.nii.gz" # Materia blanca

    if [[ -f $CSF && -f $GM && -f $WM ]]; then
        # Calcular volúmenes en mm3
        VOL_CSF=$(fslstats $CSF -M -V | awk '{print $1*$2}') # Volumen del LCR
        VOL_GM=$(fslstats $GM -M -V | awk '{print $1*$2}') # Volumen de la materia gris
        VOL_WM=$(fslstats $WM -M -V | awk '{print $1*$2}') # Volumen de la materia blanca

        # ICV total
        ICV=$(echo "$VOL_CSF + $VOL_GM + $VOL_WM" | bc) # Calcular ICV

        # Normalizados
        GM_NORM=$(echo "scale=6; $VOL_GM/$ICV" | bc) # Materia gris normalizada con el ICV
        WM_NORM=$(echo "scale=6; $VOL_WM/$ICV" | bc) # Materia blanca normalizada con el ICV
        CSF_NORM=$(echo "scale=6; $VOL_CSF/$ICV" | bc) # LCR normalizada con el ICV

        echo -e "${SUBJ}\t${VOL_GM}\t${VOL_WM}\t${VOL_CSF}\t${ICV}\t${GM_NORM}\t${WM_NORM}\t${CSF_NORM}" >> $OUT_FILE
        echo ">>> $SUBJ listo (ICV=${ICV} mm3)"
    else
        echo "⚠️ Archivos faltantes para $SUBJ"
    fi
done

echo "✅ Resultados guardados en $OUT_FILE"
