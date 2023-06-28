# Comentarios generación data

lun 12/06

## Comentarios generales

- **Proceso para generar la data**. Para generar la data, la recomendación es ejecutar el archivo `generacion_data.r`. Si se quiere revisar el código, deben revisar en los scripts particulares.

- **Organización de las carpetas**. Decidí reorganizar el trabajo guardando todos los recursos del script `generacion_data.r` (otros scripts y bases de datos) en la carpeta "files".

- Antiguamente iba a organizar los scripts y data de cada dimensión en una carpeta particular, pero la opción de usar solo una carpeta es más parsimoniosa.

- **Próximos pasos**. Con la mayoría de las variables importadas, comenzaré el trabajo de redactar el codebook a medidados de esta semana. Lo último es actualizar el código a una automatización del mismo.

- **Sobre escribir en inglés (no es tan importante)**. Además, estoy manteniendo los comentarios del script en inglés, pero veo que no hace mucho sentido si las dimensiones del codebook y algunos archivos están en español (??). Es un detalle menor, pero no tengo problema en pasar todo a inglés.

## Comentarios particulares por dimensión

### Variables faltantes por dimensión

- **Daño por alcohol:** Todavía pendiente, pero estará en proceso de extracción durante el día.
- **Ingreso:** GDP real. No encontrado como tal en la data.
- **Conumo OH:** drinkers only, abstainers. La base de datos extraída requiere de una revisión más a fondo.

### 01-Dimensión de Daño por Alcohol

- Con el propósito de confeccionar una base de datos lo antes posible, la extracción se realizó de manera manual. Doy el detalle por variable:
  - `deaths` corresponde a la primera variable: *cantidad de muertes atribuídas a *

### 02-Dimensión de Ingreso

- La dimensión ingreso está lista, a excepción de la extracción de "PIB real/real GDP" (variable 11). La única opción hasta el momento es hacer web scraping de una variable sustituta, que sería el aumento porcentual del PIB real (revisar codebook). El proceso de Web Scraping del PIB real es un proceso que decidí no priorizar en detrimento la extracción del resto de variables.

### 03-Dimensión "Consumo OH"

- La data de la dimensión de "Consumo de Alcohol" es la que tiene **información más limitada**.
  
  - En general, las variables tienen un código o más asociados. Cada código tiene dos versiones: uno archivado y otro no archivado. Si el código archivado generaba extraía una data con similares años de medición y países, se decidía priorizar la versión "no archivada", al considerarse más actualizada.
  
  - Ojo: los datos que se registran como "archivados" ("ARCHIVED") podrían estar desactualizados, pero se optó usarlos para complementar la data.

> **Ejemplo**: la data `apc_3` es data archivada (proviene del code_ID: SA_0000001822_ARCHIVED"), y tiene mediciones del año 2010, al igual que la data no archivada. Por esto, se decide excluir los datos del 2010 de esta data. Como indica el comentario, también se excluyó uno de los códigos archivados (contenía una muestra de 58 países, aprox).
> 
> ```r
> # Import data
> apc_1 <- gho_data("SA_0000001688") # n = 237, 2000 2005 2010 2015 2019
> apc_2 <- gho_data("SA_0000001822") # n = 194 countries, 2018
> apc_3 <- gho_data("SA_0000001822_ARCHIVED") # n = 194 countries, 2010 2016
> 
> # Omitted SA_0000001688_ARCHIVED
> 
> apc <- apc_1 %>% 
>   full_join(apc_2, by = names(.)) %>% 
>   full_join(filter(apc_3, TimeDim != 2010), by = names(.)) ; rm(apc_1, apc_2, apc_3)
> ```

- Ahora, voy a exponer el caso de cada variable:
1. `apc:` *Total per capita (15+) consumption (in litres of pure alcohol)*
   
   - Esta variable tiene una versión en la API, pero también una versión en la página de PAHO (descarga manual):
     
     - **PAHO**: https://www.paho.org/en/enlace/alcohol-consumption#level. ✅ <em style=color:green;>cuenta con los años del 2000-2019</em>, <strong style="color:red;">pero solo cuenta con la data de 60 países</strong>.
       
       > Busqué el indicador al que refiere esta base y es este: `SA_0000001688`, pero no obtengo los mismos resultados vía API.
     
     - En la **API**, la variable está disponible en los códigos: `SA_0000001688` y `SA_000000182`. Tiene acceso a muchos países ✅, pero no a todos los años.
     
     - Se optó por una extracción vía API.
   
   - La extracción tiene mediciones para ambos sexos, para hombres y para mujeres, guardadas en las variables: `apc`, `apc_male`, `apc_female`, respectivamente.
   
   - Es prbable que esta variable solo cuenta con tres años de medición (lo que se conoce como "three-year average", en la descripción de los indicadores), tiene solo estos años porque es la suma del consumo registrado + no registrado. Es este segundo indicador (consumo no registrado) el que cuenta con solo tres años de medición, lo que limitaría la estimación de la variable "consumo total".
   1. `rec_apc:` *Recorded alcohol per capita consumption*.
      
      - ✅ **Ningún problema con esta extracción**. La medición disponible en la API tiene su serie completa y su versión actualizada (no archivada) cuenta con una serie temporal sin discontinuidades 1971-2019 y una muestra de 189 países.
      
      - La extracción contiene datos de los diferentes tipos de bevida alcoholica, fueron guardados con los sufijos correspondientes.
   
   2. `unrec_apc:` *Unrecorded consumption*.
      
      - Se optó por data no archivada que contenga información nueva (otros años de medición) y una muestra de países similar al de otras extracciones (180-266). La serie temporal obtenida es discontinua y consta de los años: 2005, 2010, 2015, 2016 y 2019. No presenta categorías por sexo ni tipo de bebida alcoholica.
   
   3. `tourist:` *Tourist consumption, three-year average*.
      
      - Mismo procedimiento que la extracción anterior (`unrec_apc`). Se logró una muestra de 192 países y años discontinuos: 2010, 2016, y 2019.
   
   4. `drinkers:` *Drinkers only*.
   
      - Lamentablemente, esta data solo se encuentra para los años 2005, 2010 y 2016, la data archivada corresponde alos años 2005 y 2010 y la data actualizada corresponde al año 2016.
      
      - La base de datos actualizada solo contiene el año 2016, epro contiene demasiados datos, por lo que es probable qeu tenga datos repetidos. Todavía no logro captar a qué se debe esta repetición. **Queda suspendida de la base de datos temporalmente**  
      
      - En la base archivada, a partir del caso n 1123 hay puros missings.
   
   5. `abstainers:` *Abstainers, lifetime*.
      
      - Se optó por incorporar la data archivada y actualizada durante los años 2010 y 2016, pero la data archivada tiene solo 97 países, por lo que presentará muchos missings. La data actualizada (2016), en cambio, contiene 193 países.
      
      - !! Recomeindo descartar la data del 2010. (LO mismo para abstainers past 12 months)
      
      - **Otra data disponible.** También se encuentra disponible data de abstainers, pero para las edades 15 y 19.
   
   6. `abstainers_12m:` *Abstainers, past 12 months*.
      
      - Mismo caso que la extracción anterior: actualizada 2016 y archivada 2010. De igual modo, recomiendo descartar la versión archivada.
   
   7. `former_drinkers:` *Former drinkers*.
      
      - También disponibles para el año 2016 (actualizada, 193 países) y 2010 (archivada, 121 países).
      
      - **Otra data disponible**. También se encuentra disponible la data de "former drinkers para 15-19 años".
   
   8. `consumers_12m:`*Alcohol consumers, past 12 months (%)*.
      
      - También disponibles para el año 2016 (actualizada, 193 países) y 2010 (archivada, 136 países).
   
   9. `hed:` *Heavy episodic drinking, past 30 days*.
   
     - Uno de los códigos estaba asociado a  datos de la población:
       -`SA_0000001415_ARCHIVED:` Alcohol, heavy episodic drinking (population) past 30 days (%).
     
     - Se extraen datos de (+15), los datos solo están disponibles para el año 2016 (actualizado, 194 países) y 2010 (archivado, 122 países).
     
   10. `hed_agestd.` *Age-standardized heavy episodic drinking*.
    
     - Los años 2010 y 2016 se encontraban en la base de datos actualizada, y la base de datos archivada solo contaba con el año 2010. Por lo mismo se descartó la base de datos archivada, <b style="color:red">a pesar de que se pueden imputar datos perdidos a partir en el año 2010 de la data actualizada a partir de la data archivada, se decidió no "mezclar" ambas bases de datos de esta forma.</b> 
 
   11. `ad_12months:` *Alcohol dependence (15+), 12 month prevalence (%)*.
   
     - El año 2010 y 2016 está disponible para e
     
     - ⚠ Se dió prioridad a la data aarchivada. La versión archivada tiene más datos correspondeintes del año 2010.

   12. `aud_12m:` *Alcohol use disorders (15+), 12 month prevalence (%)*.

     - También disponibles para el año 2016 (actualizada, 194 países) y 2010 (archivada, 116 países).

   13. `ahu_12m:` *Harmful use (15+), 12 month prevalence (%)*.

     - También disponibles para el año 2016 (actualizada, 194 países) y 2010 (archivada, 116 países).
 
