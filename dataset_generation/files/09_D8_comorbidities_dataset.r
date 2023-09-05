#!/usr/bin/Rscript

start = Sys.time()

ihme_datafile <- data.table::fread("dataset_generation/files/data/IHME-GBD_2019_DATA-d1ce1140-1/IHME-GBD_2019_DATA-d1ce1140-1.csv") %>% tibble

# Look at id measures and diseases
table(ihme_datafile$measure_id, ihme_datafile$measure_name) ; table(ihme_datafile$cause_id, ihme_datafile$cause_name)
table(ihme_datafile$sex_id, ihme_datafile$sex_name)

##* measure: 1 death, 5 prevalence
##* cause: 587 diabetes, 12300 hypertensive heart disease


# 47-diabetes_mortality ---------------------------------------------------

# Data import
diabetes_mortality <- filter(ihme_datafile, measure_id == 1 & cause_id == 587) %>% 
  select(location_name, year, val) %>% 
  setNames(c("country", "year", "diabetes_mortality"))

# ISO3C code
diabetes_mortality <- diabetes_mortality %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble

# Labelled variables
diabetes_mortality <- diabetes_mortality %>% 
  mutate(diabetes_mortality = labelled(diabetes_mortality, label = "Mortality from diabetes (percentage)"))


# 48-diabetes -------------------------------------------------------------

# Data import
diabetes <- filter(ihme_datafile, measure_id == 5 & cause_id == 587) %>% 
  select(location_name, year, val) %>% 
  setNames(c("country", "year", "diabetes"))

# ISO3C code
diabetes <- diabetes %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble

# Labelled variables
diabetes <- diabetes %>% 
  mutate(diabetes = labelled(diabetes, label = "Diabetes prevalence (percentage)"))



# 49-hypertension_mortality -----------------------------------------------

# Data import
hypertension_mortality <- filter(ihme_datafile, measure_id == 1 & cause_id == 498) %>% 
  select(location_name, year, val) %>% 
  setNames(c("country", "year", "hypertension_mortality"))

# ISO3C code
hypertension_mortality <- hypertension_mortality %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble

# Labelled variables
hypertension_mortality <- hypertension_mortality %>% 
  mutate(hypertension_mortality = labelled(hypertension_mortality, label = "Hypertensive heart disease prevalence (percentage)"))


# 50-hypertension ---------------------------------------------------------

# Data import
hypertension <- filter(ihme_datafile, measure_id == 5 & cause_id == 498) %>% 
  select(location_name, year, val) %>% 
  setNames(c("country", "year", "hypertension"))

# ISO3C code
hypertension <- hypertension %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble

# Labelled variables
hypertension <- hypertension %>% 
  mutate(hypertension = labelled(hypertension, label = "Hypertension prevalence (percentage)"))


# Merge -------------------------------------------------------------------

# Joining all variables into a dataset of the dimension
comorbidities_dataset <- diabetes_mortality %>% 
  full_join(diabetes, by = c("iso3c", "year")) %>% 
  full_join(hypertension_mortality, by = c("iso3c", "year")) %>% 
  full_join(hypertension, by = c("iso3c", "year"))


# Adding the country names and reorganizing variables
comorbidities_dataset <- comorbidities_dataset %>% 
  mutate(country = countrycode(iso3c, origin = "iso3c", destination = "country.name")) %>%
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% relocate(ncol(.))

# Success message: dataset loaded
cat("\n\21 (DIM8) comorbidities_dataset (data.frame) -- successfully loaded\n\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects from the workspace
rm(list = ls()[!ls() %in% dataset_names])
gc()

