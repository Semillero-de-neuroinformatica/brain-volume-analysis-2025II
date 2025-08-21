# 8 sesiones de neuroinformática

## Bloque 1: Fundamentos y preparación (sesiones 1–3)

### Sesión 1 (Introducción al semestre)
- Explicación de que es la neuroinformática.
- Presentación del proyecto y objetivos.  
- Revisión de formatos de neuroimágenes: DICOM, NIfTI, etc.
- Revisión de herramientas de neuroinformática: FSL, mricron, Python

### Sesión 2 (Instalaciones y dataset)
- Presentar las dos opciones de instalación: 
  - FSL en Linux (Ubuntu).
  - FSL en Windows (Docker).
- Instalar linux para los que quieran en máquina virtual o dual boot y para los de docker explicar como instalarlo
- Descargar el dataest de niños supertodatos

### Sesión 3 (Instrodución a FSL y visualización)
- Introducción a FSL: qué es, para qué sirve.
- Visualizar imágenes con mricron o FSLeyes
- Explorar el dataset: ver que tienen las carpetas y como está organizado
- Usar (BET) para segmentar cerebro de imágenes.

---

## Bloque 2: Extracción de volúmenes (sesiones 4–6)

### Sesión 4 (Segmentación con FSL FAST)
- Uso de FAST (FMRIB's Automated Segmentation Tool) para dividir materia gris, blanca y LCR.  

### Sesión 5 (Atlas y regiones cerebrales)
- Introducción a atlases (Harvard-Oxford, AAL, etc.).  
- Uso de FLIRT y FNIRT para registro a un espacio estándar (MNI152).  
- Enmascarado de regiones con atlas → volúmenes por región.  

### Sesión 6 (Procesamiento)
- Usar una script de python para procesar los volúmenes
- Revisión de resultados intermedios (que no haya errores en lotes).  
- Contrastar resultados con la literatura (volúmenes esperados por región).

---

## Bloque 3: Análisis estadístico (sesiones 7–8)

### Sesión 7 (Exploración de datos)
- Importar volúmenes a Python (pandas, numpy)
- Gráficas descriptivas (boxplots, histogramas).

### Sesión 8 (Pruebas estadísticas)
- Comparaciones entre grupos (niños control vs. superdotados).  
- t-test, ANOVA o modelos lineales mixtos (según variables).  
- Corrección por comparaciones múltiples (FDR/Bonferroni).  
 
---

## Bloque 4: Cierre (sesión 9)

### Sesión 9 (Presentación final)
- Presentación interna de resultados.  
- Plan de continuidad: ¿escalarlo a un artículo, póster, congreso?  
- Documentación en GitHub/Overleaf con pipeline y resultados.  
