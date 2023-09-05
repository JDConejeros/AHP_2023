#!/usr/bin/Rscript

start = Sys.time()


# 42-temperature ----------------------------------------------------------

## NOAA

# 43-precipitation --------------------------------------------------------

precipitation <- fread("dataset_generation/files/data/average-precipitation-per-year.csv")

# Extract variables of interest
precipitation <- precipitation[,c(1,3,4)] %>% setNames(c("country", "year", "precipitation"))

# Manually ISO3c code convert
precipitation <- precipitation %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', 
                                     destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled precipitation variable
precipitation <- precipitation %>% 
  mutate(precipitation = as.numeric(precipitation),
         precipitation = labelled(precipitation, label = "Average precipitation in millimeters per year"))


# Merge -------------------------------------------------------------------

# Conformación del data.frame
environmental_characteristics_dataset <- precipitation 

# Adding the country names and reorganizing variables
environmental_characteristics_dataset <- environmental_characteristics_dataset %>% 
  mutate(country = countrycode(iso3c, origin = "iso3c", destination = "country.name")) %>%
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% relocate(ncol(.))

# Success message: dataset loaded
cat("\n\21 (DIM6) environmental_characteristics_dataset (data.frame) -- successfully loaded\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects from the workspace
rm(list = ls()[!ls() %in% dataset_names])
gc()

