#!/usr/bin/Rscript

# General
missings_general <- ahp_data %>% 
  select(-c(year, country, iso3c)) %>% 
  sapply(na_count) %>%
  as.data.frame() %>% 
  arrange(desc(.)) %>% 
  setNames(c("Missing (%)"))

missings_general$variable_names <- ahp_data %>% select(-c(year, country, iso3c)) %>% names
missings_general <- missings_general %>% relocate(ncol(.))

# By year
missings_years <- ahp_data %>% 
  select(-c(country, iso3c)) %>% 
  group_by(year) %>% 
  summarise_all(function(x) sum(is.na(x)) / 235)

# By country
missings_countries <- ahp_data %>% 
  select(-c(year, iso3c)) %>% 
  group_by(country) %>% 
  summarise_all(function(x) sum(is.na(x)) / 522)

# Data
OUT <- createWorkbook()

addWorksheet(OUT, "Missings (%) general")
addWorksheet(OUT, "Missings (%) by year")
addWorksheet(OUT, "Missings (%) by country")

writeData(OUT, sheet = "Missings (%) general", x = missings_general)
writeData(OUT, sheet = "Missings (%) by year", x = missings_years)
writeData(OUT, sheet = "Missings (%) by country", x = missings_countries)

saveWorkbook(OUT, "dataset_generation/missing_analysis/missings.xlsx")


rm(list = ls()[ls() != "ahp_data"])

