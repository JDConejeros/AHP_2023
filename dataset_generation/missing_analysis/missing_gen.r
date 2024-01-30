#!/usr/bin/Rscript

pacman::p_load(condformat)

# General
missings_general <- ahp_data %>% 
  select(-c(year, country, iso3c)) %>%
  summarise_all(na_count) %>% 
  pivot_longer(cols = everything(), names_to = "key", values_to = "value") %>% 
  arrange(desc(value)) %>% 
  setNames(c("Variable", "Missing (%)"))

missings_year <- ahp_data %>% 
  select(-c(country, iso3c)) %>%
  group_by(year) %>%
  summarise_all(na_count)

missings_country <- ahp_data %>% 
  select(-c(year, iso3c)) %>%
  group_by(country) %>%
  summarise_all(na_count)

condformat(missings_country) %>%
    rule_fill_discrete('PERCENT', expression=cut(df$PERCENT, breaks=c(0,80,90,100), include.lowest=T, labels=F), colours=c('1'='red', '2'='orange', '3'='green'))
# Data
OUT <- createWorkbook()

addWorksheet(OUT, "Missings (%) general")
addWorksheet(OUT, "Missings (%) by year")
addWorksheet(OUT, "Missings (%) by country")

writeData(OUT, sheet = "Missings (%) general", x = missings_general)
writeData(OUT, sheet = "Missings (%) by year", x = missings_year)
writeData(OUT, sheet = "Missings (%) by country", x = missings_country)

saveWorkbook(OUT, "dataset_generation/missing_analysis/missings.xlsx")

