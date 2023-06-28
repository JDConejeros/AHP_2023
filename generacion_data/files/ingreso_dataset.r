#!/usr/bin/Rscript

start = Sys.time()

# Pendientes:
# ¿Podemos automatizar la limpiezade la data de World Bank con map o map_df? Sí, pero empecemos a mano primero
# EL procedimiento para asignar código iso3 es el de transformar diréctamente del nombre completo de los países y no confiar en el iso3 por defecto de los datasets.
# Falta un sistema (función) para demostrar que el etiquetado por iso3c se hizo correctamente.

# 6-gdp -------------------------------------------------------------------

# Import data
gdp <- WDI(indicator = "NY.GDP.MKTP.CD")

# Extracting variables of interest
gdp <- gdp[,c(1,4,5)] %>% setNames(c("country", "year", "gdp"))

# Manually ISO3c code convert
gdp <- gdp %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled gdp variable
gdp <- gdp %>% 
  mutate(gdp = as.numeric(gdp),
         gdp = labelled(gdp, label = "Nominal GDP (current US$)"))


# 7-gdp-per-capita --------------------------------------------------------

# Import data
gdp_per_capita <- WDI(indicator = "NY.GDP.PCAP.CD") 

# Extract and rename variables of interest
gdp_per_capita <- gdp_per_capita[,c(1,4,5)] %>% setNames(c("country", "year", "gdp_per_capita"))

# iso3c code asignation
gdp_per_capita <- gdp_per_capita %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>%
  as_tibble %>% 
  filter(!is.na(iso3c))


# Labelled variable
gdp_per_capita <- gdp_per_capita %>% 
  mutate(gdp_per_capita = as.numeric(gdp_per_capita),
         gdp_per_capita = labelled(gdp_per_capita, label = "Nominal GDP per capita (current US$)"))

# 8-hcpi ------------------------------------------------------------------

# Database site: https://www.worldbank.org/en/research/brief/inflation-database
# Download link: https://thedocs.worldbank.org/en/doc/1ad246272dbbc437c74323719506aa0c-0350012021/related/Inflation-data.zip

# Import data file
hcpi <- read_dta("generacion_data/files/data/Inflation-data/hcpi_a.dta") %>% select(-c(59:64))

# Convert to long data
hcpi <- hcpi %>% 
  gather(key = "year", value = "hcpi", -names(.)[c(1:5)])

# Rename and handle
hcpi <- hcpi %>% 
  select(c(3, 6, 7)) %>% 
  mutate(year = str_remove(year, "i"),
         year = as.numeric(year)) %>%
  janitor::clean_names()

# iso3c code asignation
hcpi <- hcpi %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>%
  select(-country) %>%
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled variable
hcpi <- hcpi %>% 
  mutate(hcpi = as.numeric(hcpi),
         hcpi = labelled(hcpi, label = "Headline consumer price inflation (annual)"))


# 9-cpi -------------------------------------------------------------------

# Importación de datos
cpi <- WDI(indicator = "FP.CPI.TOTL.ZG")

# Extraer variables de interés
cpi <- cpi[,c(1,4,5)] %>% setNames(c("country", "year", "cpi"))

# iso3c code asignation
cpi <- cpi %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>%
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled variable
cpi <- cpi %>% 
  mutate(cpi = as.numeric(cpi),
         cpi = labelled(cpi, label = "Inflation, consumer prices (annual %)"))

# 10-deflacor -------------------------------------------------------------

# Deflator import database
deflator <- WDI(indicator = "NY.GDP.DEFL.KD.ZG")

# Extraer variables de interés
deflator <- deflator[,c(1,4,5)] %>% setNames(c("country", "year", "deflator"))

# iso3c code asignation
deflator <- deflator %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>%
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled variable
deflator <- deflator %>% 
  mutate(deflator = as.numeric(deflator),
         deflator = labelled(deflator, label = "GDP deflator (annual %)"))

# 11-gdp_real -------------------------------------------------------------

## PENDIENTE ----

# 12-gdp_real_per_capita --------------------------------------------------

# Query OWID API using the owidR package
gdp_real_per_capita <- owid(chart_id = "gdp-per-capita-worldbank")

# Extracting and rename variables of interest
gdp_real_per_capita <- gdp_real_per_capita[,c(1, 3, 4)] %>% 
  setNames(c("country", "year", "gdp_real_per_capita"))

# iso3c code asignation
gdp_real_per_capita <- gdp_real_per_capita %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>%
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled variable
gdp_real_per_capita <- gdp_real_per_capita %>% 
  mutate(gdp_real_per_capita = as.numeric(gdp_real_per_capita),
         gdp_real_per_capita = labelled(gdp_real_per_capita, label = "Real GDP per capita (adjusted for inflation and differences in cost of living)"))



# Merge -------------------------------------------------------------------

ingreso_dataset <- gdp %>% 
  full_join(gdp_per_capita, by = c("iso3c", "year")) %>% 
  full_join(hcpi, by = c("iso3c", "year")) %>% 
  full_join(cpi, by = c("iso3c", "year")) %>% 
  full_join(deflator, by = c("iso3c", "year")) %>% 
  full_join(gdp_real_per_capita, by = c("iso3c", "year"))


# Lablled country data
ingreso_dataset <- ingreso_dataset %>% 
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% 
  rename("country" = "iso3c")

vtable::vtable(ingreso_dataset)

# Success message!
print(cat("\n\3 Cargado con éxito: dataset ingreso_dataset\n"))

end = Sys.time() - start ; print(end)

