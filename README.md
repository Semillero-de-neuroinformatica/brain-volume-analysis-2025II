# Curso de Neuroinformática: Análisis de Volúmenes Cerebrales

# Descripción del curso

En este curso de neuroinformática, dado por SNEIA, aprenderemos a usar FSL para hacer analisis volumétricos de resonancia magnética cerebral. Utilizaremos un dataset de OpenNeuro que contiene imágenes T1w de 29 sujetos, y aprenderemos a procesar y analizar estas resonancias para comprender como varia el volumen de las regiones del cerebro en niños superdotados y control.

## 🎯 Objetivos del Curso

- Introducir conceptos fundamentales de neuroinformática
- Enseñar el uso de herramientas especializadas (FSL, Python)
- Desarrollar habilidades en procesamiento de neuroimágenes
- Realizar análisis estadísticos de datos cerebrales
- Presentar resultados científicos de manera profesional

## 📊 Dataset

**Fuente:** [OpenNeuro ds002726](https://openneuro.org/datasets/ds002726/versions/1.0.1/)

El dataset contiene:
- **29 sujetos** (sub-01 a sub-29)
- **Imágenes T1w** en formato NIfTI (.nii.gz)
- **Metadatos** en formato JSON
- **Datos derivados** en formato MATLAB (.mat.gz)

## Descargar Dataset

- Crear una carpeta llamada `dataset` en el directorio del proyecto.
- Descargar el dataset desde OpenNeuro y descomprimirlo en la carpeta [dataset](https://openneuro.org/datasets/ds002726/versions/1.0.1/).

### Estructura del Dataset
```
dataset/
├── sub-01/ ... sub-29/     # Datos de cada sujeto
│   └── anat/
│       ├── sub-XX_T1w.nii.gz
│       └── sub-XX_T1w.json
├── derivatives/            # Datos procesados
└── dataset_description.json
```

## 🛠️ Instalación y Configuración

### Prerrequisitos
- **Sistema Operativo:** Linux (Ubuntu recomendado) o Windows con Docker
- **Python:** 3.7 o superior
- **Espacio en disco:** ~5GB para el dataset

## 🚀 Flujo de Trabajo

1. **Preparación:** Instalación de herramientas y descarga de datos
2. **Visualización:** Exploración inicial de las neuroimágenes
3. **Segmentación:** Separación de tejidos cerebrales
4. **Registro:** Alineación a espacio estándar
5. **Extracción:** Cálculo de volúmenes por región
6. **Análisis:** Estadísticas descriptivas e inferenciales
7. **Presentación:** Comunicación de resultados

## 🤝 Contribuciones

Este proyecto es parte del curso de neuroinformática. Los estudiantes pueden contribuir:
- Mejorando scripts de procesamiento
- Documentando procedimientos
- Reportando errores o problemas
- Sugiriendo análisis adicionales

## 📝 Licencia

Este proyecto tiene fines educativos. El dataset original está bajo la licencia Creative Commons. Ver [OpenNeuro](https://openneuro.org/datasets/ds002726) para más detalles.

## 👥 Autores

- **Curso:** Semillero de Neuroinformática e Inteligencia Artificial (SNEIA), Univerisdad Technológica de Pereira (UTP) 
- **Instructores:** Victor Correa, Santiago Angel, Isabella Cardona, Mariana Telléz, Mateo Morales.
- **Dataset:** [Disponible en OpenNeuro](https://openneuro.org/datasets/ds002726/)
- **Revista del dataset** [Spring Nature](https://link.springer.com/article/10.1007/s00429-019-01914-9)
- **Herramientas:** FSL, Python, neuroimaging libraries

---

**¡Bienvenidos al fascinante mundo de la neuroinformática!** 🧠✨