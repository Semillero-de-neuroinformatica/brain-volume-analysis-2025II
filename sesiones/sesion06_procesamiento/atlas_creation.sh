#!/bin/bash

# --- Ruta de entrada ---
INPUT_DIR="../../atlas/nihpd_sym_10.0-14.0_nifti"
T1_IMAGE="$INPUT_DIR/nihpd_sym_10.0-14.0_t1w.nii"
MASK_IMAGE="$INPUT_DIR/nihpd_sym_10.0-14.0_mask.nii"

# --- Carpeta de salida ---
OUTPUT_DIR="atlas"
OUTPUT_NAME="nihpd_sym_10.0-14.0_t1w_masked.nii.gz"

# --- Crear carpeta si no existe ---
mkdir -p $OUTPUT_DIR

# --- Aplicar máscara al T1 ---
fslmaths $T1_IMAGE -mas $MASK_IMAGE $OUTPUT_DIR/$OUTPUT_NAME

echo "✅ Archivo creado en: $OUTPUT_DIR/$OUTPUT_NAME"
