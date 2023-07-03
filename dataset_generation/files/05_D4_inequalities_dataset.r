
# heq

heq <- readRDS("dataset_generation/files/data/V-Dem-CY-Core_R_v13/V-Dem-CY-Core-v13.rds") %>% tibble
head(heq)

## Codebook

heq %>% names %>% cbind

heq[, c()]

# gini

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





