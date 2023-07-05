#!/usr/bin/Rscript

start = Sys.time()


# 24-heq ------------------------------------------------------------------

heq <- readRDS("dataset_generation/files/data/V-Dem-CY-Core_R_v13/V-Dem-CY-Core-v13.rds") %>% tibble

# Codebook: https://v-dem.net/documents/24/codebook_v13.pdf

# select variables
heq <- heq[, c("country_name", "year", "v2pehealth")] %>% 
  setNames(c("country", "year", "heq")) %>% 
  filter(year >= 1960)

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


# 26-income_inequality ----------------------------------------------------

# Pendiente

# Merge -------------------------------------------------------------------
inequalities_dataset <- heq %>% 
  full_join(gini, by = c("iso3c", "year"))


# Lablled country data
inequalities_dataset <- inequalities_dataset %>% 
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% 
  rename("country" = "iso3c")

# Success message!
cat("\n\21 (DIM4) dataset inequalities_dataset -- successfully loaded\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects
rm(list = ls()[!ls() %in% c("alcohol_harm_dataset", "income_dataset", "consumption_dataset",
                            "inequalities_dataset")])

