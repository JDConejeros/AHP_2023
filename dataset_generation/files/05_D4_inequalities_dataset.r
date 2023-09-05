#!/usr/bin/Rscript

start = Sys.time()


# 24-heq ------------------------------------------------------------------

# Data import
heq <- readRDS("dataset_generation/files/data/V-Dem-CY-Core_R_v13/V-Dem-CY-Core-v13.rds")

# Codebook: https://v-dem.net/documents/24/codebook_v13.pdf

# select variables
heq <- heq[, c("country_name", "year", "v2pehealth")] %>%
  setNames(c("country", "year", "heq")) %>%
  filter(year >= 1960 & country != "Palestina/Gaza")

# iso3c code (warnings)
heq <- heq %>%
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>%
  relocate(ncol(.), 1:(ncol(.)-1)) %>%
  select(-country) %>%
  as_tibble %>%
  filter(!is.na(iso3c))

# Labelled variable
heq <- heq %>%
  mutate(heq = labelled(heq, label = "Health Equality (V-Dem v13)"))

# 25-gini -----------------------------------------------------------------
gini <- WDI(indicator = "SI.POV.GINI")

# Extraer variables de interés
gini <- gini[,c(1,4,5)] %>%
     setNames(c("country", "year", "gini"))

# iso3c code asignation
gini <- gini %>%
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>%
  relocate(ncol(.), 1:(ncol(.)-1)) %>%
  select(-country) %>%
  as_tibble %>%
  filter(!is.na(iso3c))

# Labelled variable
gini <- gini %>%
  mutate(gini = labelled(gini, label = "Gini Index"))

globalSummary(gini, country_name = "iso3c")

# 26-income_inequality ----------------------------------------------------

# Pendiente

# Merge -------------------------------------------------------------------

# Joining all variables into a dataset of the dimension
inequalities_dataset <- heq %>% 
  full_join(gini, by = c("iso3c", "year"))

# Adding the country names and reorganizing variables
inequalities_dataset <- inequalities_dataset %>% 
  mutate(country = countrycode(iso3c, origin = "iso3c", destination = "country.name")) %>%
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% relocate(ncol(.))
         

# Success message: dataset loaded
cat("\n\21 (DIM4)  inequalities_dataset (data.frame) -- successfully loaded\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects from the workspace
rm(list = ls()[!ls() %in% dataset_names])
gc()

