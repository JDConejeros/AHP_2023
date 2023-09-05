#!/usr/bin/Rscript

start = Sys.time()


# 51-hospital_beds --------------------------------------------------------

# Import data
hospital_beds <- WDI(indicator = "SH.MED.BEDS.ZS")

# Extracting variables of interest
hospital_beds <- hospital_beds[,c(1,4,5)] %>% setNames(c("country", "year", "hospital_beds"))

# Manually ISO3c code convert
hospital_beds <- hospital_beds %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled hospital_beds variable
hospital_beds <- hospital_beds %>% 
  mutate(hospital_beds = as.numeric(hospital_beds),
         hospital_beds = labelled(hospital_beds, label = "Hospital beds (per 1,000 people)"))

# Merge -------------------------------------------------------------------

# Conformación del data.frame
infrastructure_dataset <- hospital_beds

# Adding the country names and reorganizing variables
infrastructure_dataset <- infrastructure_dataset %>% 
  mutate(country = countrycode(iso3c, origin = "iso3c", destination = "country.name")) %>%
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% relocate(ncol(.))

# Success message: dataset loaded
cat("\n\21 (DIM9) dataset infrastructure_dataset -- successfully loaded\n\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects from the workspace
rm(list = ls()[!ls() %in% dataset_names])
gc()

