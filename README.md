# Proyecto Final — Solución BI y Big Data: Colores y Creaciones

**Curso:** Base de Datos Avanzadas y Big Data
**Carrera:** Ingeniería de Sistemas Computacionales — Universidad Privada del Norte (UPN)
**Período:** 2026-2

## Descripción general
Este repositorio reúne los scripts, configuraciones y evidencias del proyecto final desarrollado para **Colores y Creaciones**, integrando una solución de **Inteligencia de Negocios** (SQL Server, ETL en Visual Studio y **Power BI**) y una solución de **Big Data** (Apache Spark / PySpark ejecutado en **Google Colab**), empleando **MongoDB**  exclusivamente como fuente de datos documental.El entorno de desarrollo y edición de código/archivos del proyecto incluye **Visual Studio 2026** y **Visual Studio Code**.

## Estructura del repositorio
```text
colores-y-creaciones-repo/
├── README.md
├── requirements.txt
├── .gitignore
├── .env.example
├── sql/          # Scripts OLTP, modelo dimensional (DW), seguridad y respaldos
├── etl/          # Solución y paquetes ETL en Visual Studio (ColoresyCreaciones_ETL.slnx)
├── spark/        # Exportación a Parquet, procesamiento en capas y benchmark experimental (Colab/PySpark)
├── mongo/        # Esquema/índices y lectura documental de detallespersonalizados
├── powerbi/      # Modelo, reportes o referencias del dashboard en Power BI (si aplica por tamaño)
└── evidencias/   # Consolidado de métricas (resultados.csv) y evidencias ligeras