
# Generacion Data

## Instrucciones de uso

- Ejecutar el archivo generacion_data.r para generar la data extraída hasta el momento.

  - 🎯 Comentarios de la versión actual en: [notes](notes.md). 

## Tareas de la generación de la data

### Importantes

- [ ] Extracción de datos de las dimensiones.
  - [x] Daño por alcohol (durante el día)
  - [x] Ingreso
  - [x] Consumo OH
  - [ ] Desigualdades\*
  - [x] Características de la población
  - [ ] Características ambientales
  - [x] Factores de Riesgo
  - [x] Comorbilidades
  - [x] Infraestructura y servicios públicos
  - [x] Políticas públicas (especificación pendiente)
- [ ] Tabla de missings por variable.
- [ ] Investigación del proceso de extracción, origen, estimación y descripción de lo que mide cada variable. Especialmente, las variables de **Ingreso** y **Consumo**.

_\* En la dimensión 4 de «desigualdades» (inequalities), queda pendiente determinar qué variable de la base de datos del WID añadimos como «income inequalities»_.

### Tareas secundarias

- [ ] Mejorar el proceso de extracción de las variables de "Daño por Alcohol", consultando la **API de IHME**.
- [ ] Automatizar los procesos de extracción de datos, especialmente si provienen de fuentes similares.
- [ ] Añadir un archivo de proyecto a la carpeta generacion_data y cambiar los directorios.

