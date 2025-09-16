# Scripts de Procesamiento de Análisis de Volumen Cerebral

Este documento explica cada uno de los scripts utilizados en el pipeline de análisis de volumen cerebral, describiendo su propósito, funcionamiento y lugar en el flujo de trabajo.

## ⚠️ Nota Importante sobre el Atlas
El script `atlas_creation.sh` no funciona correctamente y no debe ser utilizado en el pipeline actual.

## 📋 Índice de Scripts

1. [bet_pipeline.sh](#1-bet_pipelinesh) - Extracción cerebral
2. [flirt_pipeline.sh](#2-flirt_pipelinesh) - Registro linear
3. [fast_pipeline.sh](#3-fast_pipelinesh) - Segmentación de tejidos
4. [first_module.sh](#4-first_modulesh) - Segmentación subcortical
5. [icv_module.sh](#5-icv_modulesh) - Cálculo de volúmenes ICV
6. [get_volumes.sh](#6-get_volumessh) - Extracción de volúmenes subcorticales

---

## 1. bet_pipeline.sh

### 🎯 Propósito
Extrae el tejido cerebral de las imágenes T1 originales, eliminando el cráneo y tejidos no cerebrales usando FSL BET (Brain Extraction Tool).

### 🔧 Funcionamiento
```bash
# BET: Brain Extraction Tool
bet "$T1_FILE" "$OUT_FILE" -f 0.4 -g 0 -R
```

### 📊 Parámetros BET
- `-f 0.4`: Umbral de fracción de intensidad (0.4 = valor conservador)
- `-g 0`: Desplazamiento vertical del umbral
- `-R`: Modo robusto para imágenes con variabilidad

### 📁 Archivos de Entrada
- `../../dataset/sub-*/anat/sub-*_T1w.nii.gz` - Imágenes T1 originales de cada sujeto

### 📄 Archivos de Salida
- `./brains/sub-*_T1w_brain.nii.gz` - Cerebros extraídos para cada sujeto

### 🔄 Posición en el Pipeline
**PASO 1** - Primera etapa del procesamiento

---

## 2. flirt_pipeline.sh

### 🎯 Propósito
Registra linealmente cada cerebro extraído al espacio del atlas usando FLIRT (FMRIB's Linear Image Registration Tool), permitiendo comparaciones entre sujetos.

### 🔧 Funcionamiento
```bash
flirt -in $BRAIN_FILE \
      -ref $ATLAS \
      -out ${OUT_PREFIX}.nii.gz \
      -omat ${OUT_PREFIX}.mat \
      -bins 256 -cost corratio \
      -searchrx -90 90 -searchry -90 90 -searchrz -90 90 \
      -dof 12 -interp trilinear
```

### 📊 Parámetros FLIRT
- `-cost corratio`: Función de costo (correlación normalizada)
- `-dof 12`: 12 grados de libertad (transformación afín completa)
- `-bins 256`: Número de bins para el histograma
- `-search*`: Rangos de búsqueda en rotación (±90°)
- `-interp trilinear`: Interpolación trilineal

### 📁 Archivos de Entrada
- `./brains/sub-*_T1w_brain.nii.gz` - Cerebros extraídos
- `../../atlas/nihpd_sym_10.0-14.0_t1w.nii` - Atlas de referencia

### 📄 Archivos de Salida
- `./flirt/sub-*_flirt.nii.gz` - Imágenes registradas al atlas
- `./flirt/sub-*_flirt.mat` - Matrices de transformación

### 🔄 Posición en el Pipeline
**PASO 2** - Después de bet_pipeline.sh (opcional, puede ejecutarse en paralelo con FAST)

---

## 3. fast_pipeline.sh

### 🎯 Propósito
Segmenta cada cerebro en tres tipos de tejido: materia gris (GM), materia blanca (WM) y líquido cefalorraquídeo (CSF) usando FSL FAST.

### 🔧 Funcionamiento
```bash
fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -o $OUT_PREFIX $BRAIN_FILE
```

### 📊 Parámetros FAST
- `-t 1`: Tipo de imagen (1 = T1-weighted)
- `-n 3`: Número de clases de tejido (GM, WM, CSF)
- `-H 0.1`: Factor de suavizado espacial
- `-I 4`: Número de iteraciones del algoritmo EM
- `-l 20.0`: Umbral para eliminar componentes pequeños

### 📁 Archivos de Entrada
- `./brains/sub-*_T1w_brain.nii.gz` - Cerebros extraídos

### 📄 Archivos de Salida
- `./fast/sub-*_fast_seg.nii.gz` - Segmentación etiquetada
- `./fast/sub-*_fast_pve_0.nii.gz` - Mapa de probabilidad CSF
- `./fast/sub-*_fast_pve_1.nii.gz` - Mapa de probabilidad GM
- `./fast/sub-*_fast_pve_2.nii.gz` - Mapa de probabilidad WM

### 🔄 Posición en el Pipeline
**PASO 3** - Después de bet_pipeline.sh

---

## 4. first_module.sh

### 🎯 Propósito
Segmenta estructuras subcorticales específicas (hipocampo, tálamo, caudado, etc.) usando FSL FIRST (FMRIB's Integrated Registration and Segmentation Tool).

### 🔧 Funcionamiento
```bash
run_first_all -i $BRAIN_FILE -o $OUT_PREFIX \
  -s L_Hipp,R_Hipp,L_Thal,R_Thal,L_Caud,R_Caud,L_Puta,R_Puta,L_Pall,R_Pall,L_Amyg,R_Amyg,BrStem
```

### 🧠 Estructuras Segmentadas
- **L_Hipp/R_Hipp**: Hipocampo izquierdo/derecho
- **L_Thal/R_Thal**: Tálamo izquierdo/derecho
- **L_Caud/R_Caud**: Núcleo caudado izquierdo/derecho
- **L_Puta/R_Puta**: Putamen izquierdo/derecho
- **L_Pall/R_Pall**: Globo pálido izquierdo/derecho
- **L_Amyg/R_Amyg**: Amígdala izquierda/derecha
- **BrStem**: Tronco cerebral

### 📁 Archivos de Entrada
- `./brains/sub-*_T1w_brain.nii.gz` - Cerebros extraídos

### 📄 Archivos de Salida
- `./first/sub-*_first-*_first.nii.gz` - Segmentaciones individuales por estructura
- `./first/sub-*_first_all_fast_origsegs.nii.gz` - Segmentación combinada con etiquetas

### ⚠️ Sujetos Excluidos
- sub-09, sub-11, sub-12, sub-17, sub-18, sub-20 (problemas en el procesamiento)

### 🔄 Posición en el Pipeline
**PASO 4** - Después de bet_pipeline.sh (puede ejecutarse en paralelo con FAST)

---

## 5. icv_module.sh

### 🎯 Propósito
Calcula los volúmenes de materia gris, blanca y CSF, así como el volumen intracraneal total (ICV) y proporciones normalizadas.

### 🔧 Funcionamiento
```bash
# Calcular volúmenes en mm³
VOL_CSF=$(fslstats $CSF -M -V | awk '{print $1*$2}')
VOL_GM=$(fslstats $GM -M -V | awk '{print $1*$2}')
VOL_WM=$(fslstats $WM -M -V | awk '{print $1*$2}')

# ICV total
ICV=$(echo "$VOL_CSF + $VOL_GM + $VOL_WM" | bc)

# Normalizaciones
GM_NORM=$(echo "scale=6; $VOL_GM/$ICV" | bc)
```

### 📊 Métricas Calculadas
- **Volúmenes absolutos** (mm³): GM, WM, CSF
- **ICV**: Volumen intracraneal total (GM + WM + CSF)
- **Volúmenes normalizados**: Proporciones relativas al ICV

### 📁 Archivos de Entrada
- `./fast/sub-*_fast_pve_*.nii.gz` - Mapas de probabilidad de FAST

### 📄 Archivos de Salida
- `./icv/volumes_results.tsv` - Tabla con todos los volúmenes calculados

### 🔄 Posición en el Pipeline
**PASO 5** - Después de fast_pipeline.sh

---

## 6. get_volumes.sh

### 🎯 Propósito
Extrae volúmenes específicos de las estructuras subcorticales segmentadas por FIRST, usando etiquetas numéricas predefinidas.

### 🔧 Funcionamiento
```bash
# Para cada etiqueta, extraer número de vóxeles y volumen
RES=$(fslstats $FILE -l $(echo "$LABEL-0.5" | bc) -u $(echo "$LABEL+0.5" | bc) -V)
NUM=$(echo $RES | awk '{print $1}')  # Número de vóxeles
VOL=$(echo $RES | awk '{print $2}')  # Volumen en mm³
```

### 🏷️ Mapeo de Etiquetas
| Etiqueta | Estructura | Descripción |
|----------|------------|-------------|
| 10 | L_Thal | Tálamo izquierdo |
| 11 | L_Caud | Caudado izquierdo |
| 12 | L_Puta | Putamen izquierdo |
| 13 | L_Pall | Globo pálido izquierdo |
| 16 | BrStem | Tronco cerebral |
| 17 | L_Hipp | Hipocampo izquierdo |
| 18 | L_Amyg | Amígdala izquierda |
| 49 | R_Thal | Tálamo derecho |
| 50 | R_Caud | Caudado derecho |
| 51 | R_Puta | Putamen derecho |
| 52 | R_Pall | Globo pálido derecho |
| 53 | R_Hipp | Hipocampo derecho |
| 54 | R_Amyg | Amígdala derecha |

### 📁 Archivos de Entrada
- `./first/sub-*_first_all_fast_origsegs.nii.gz` - Segmentaciones etiquetadas de FIRST

### 📄 Archivos de Salida
- `./subcortical_volumes/volumenes_first.csv` - Tabla CSV con volúmenes subcorticales

### 🔄 Posición en el Pipeline
**PASO 6** - Después de first_module.sh

---

## 🔄 Flujo Completo del Pipeline

```
1. bet_pipeline.sh       → Extraer cerebros de todas las imágenes T1
2. fast_pipeline.sh      → Segmentar tejidos (GM, WM, CSF)
3. first_module.sh       → Segmentar estructuras subcorticales
4. icv_module.sh         → Calcular volúmenes ICV y normalizaciones
5. get_volumes.sh        → Extraer volúmenes subcorticales específicos
6. flirt_pipeline.sh     → Registro al atlas (opcional)
```

## 📊 Archivos Finales de Resultados

- `./icv/volumes_results.tsv` - Volúmenes de tejidos y ICV
- `./subcortical_volumes/volumenes_first.csv` - Volúmenes subcorticales

## 🛠️ Dependencias

- **FSL** (FMRIB Software Library)
  - `bet` - Brain Extraction Tool
  - `fast` - Segmentación de tejidos
  - `first` / `run_first_all` - Segmentación subcortical
  - `flirt` - Registro linear
  - `fslmaths` - Operaciones matemáticas en imágenes
  - `fslstats` - Estadísticas de imágenes

## ⚙️ Variables de Entorno

```bash
export FSLPARALLEL=""  # Desactivar paralelismo en algunos scripts
```

## 📝 Notas Importantes

1. **Orden de ejecución**: Respetar la secuencia del pipeline
2. **Verificación de archivos**: Cada script verifica si ya existen resultados antes de procesar
3. **Sujetos problemáticos**: Algunos sujetos se excluyen automáticamente debido a problemas de calidad
4. **Formato de datos**: Entrada en formato BIDS, salida en formato tabular para análisis estadístico