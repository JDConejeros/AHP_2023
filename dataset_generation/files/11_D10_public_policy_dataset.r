#!/usr/bin/Rscript

start = Sys.time()

# 52-health_expenditure ---------------------------------------------------

# Import data
health_expenditure <- WDI(indicator = c("health_expenditure" = "SH.XPD.CHEX.GD.ZS"))

# Extracting variables of interest
health_expenditure <- health_expenditure %>% select(country, year, health_expenditure)

# Manually ISO3c code convert
health_expenditure <- health_expenditure %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled health_expenditure variable
health_expenditure <- health_expenditure %>% 
  mutate(health_expenditure = as.numeric(health_expenditure),
         health_expenditure = labelled(health_expenditure, label = "Current health expenditure (% of GDP)"))

# Merge -------------------------------------------------------------------

# Conformación del data.frame
public_policy_dataset <- health_expenditure # add public policy variables

# Adding the country names and reorganizing variables
public_policy_dataset <- public_policy_dataset %>% 
  mutate(country = countrycode(iso3c, origin = "iso3c", destination = "country.name")) %>%
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% relocate(ncol(.))

# Success message: dataset loaded
cat("\n\21 (DIM10) dataset public_policy_dataset -- successfully loaded\n\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects from the workspace
rm(list = ls()[!ls() %in% dataset_names])
gc()

