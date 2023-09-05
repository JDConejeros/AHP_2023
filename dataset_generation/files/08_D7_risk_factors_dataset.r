#!/usr/bin/Rscript

start = Sys.time()

# 44-obesity --------------------------------------------------------------

# Data import
obesity <- gho_data("NCD_BMI_30C") %>% filter(Dim1 == "BTSX" & SpatialDimType == "COUNTRY") 

# Rename variables and prepare categories
obesity <- obesity[,c(4,6,8,16)] %>% 
  setNames(c("iso3c", "year", "dim", "obesity")) %>% 
  select(-dim)

# ISO3C code
obesity <- obesity %>% 
  mutate(country = countrycode(iso3c, origin = 'iso3c', destination = 'country.name')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble

# Labelled variables
obesity <- obesity %>% 
  mutate(obesity = labelled(obesity, label = "Prevalence of obesity among adults, BMI ≥ 30 (crude estimate) (%)"))


# 45-bmi ------------------------------------------------------------------

# Import data
bmi <- gho_data("NCD_BMI_MEANC") %>% filter(Dim1 == "BTSX" & SpatialDimType == "COUNTRY" & Dim2 == "YEARS18-PLUS")

# Rename variables and prepare categories
bmi <- bmi[,c(4,6,8,16)] %>% 
  setNames(c("iso3c", "year", "dim", "bmi")) %>% 
  select(-dim)

# ISO3C code
bmi <- bmi %>% 
  mutate(country = countrycode(iso3c, origin = 'iso3c', destination = 'country.name')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble

# Labelled variables
bmi <- bmi %>% 
  mutate(bmi = labelled(bmi, label = "Mean Body Mass Index +18 (kg/m2) (crude estimate)"))



# 46-smoking --------------------------------------------------------------

# Set IHME API endopoint url
endpoint <- "https://api.healthdata.org/sdg/v1/GetResultsByIndicator"

# Set API key
apikey <- "ijibewtybkxwp79a8ps2zie2ec5zxunn"

# Define query parameters
query_string <- list(indicator_id = 1243)

# Make a GET request
r <- VERB("GET", endpoint, 
          query = query_string,
          add_headers("Authorization" = apikey), 
          accept("application/json"))

# Extract json data content as text
text_content <- content(r, "text", encoding = "UTF-8")

# Convert the JSON response to a dataframe
smoking <- fromJSON(text_content)$results %>% 
  filter(year_id <= 2021 & sex_id == 3) %>% 
  tibble

# Rename variables and prepare categories
smoking <- smoking[,c(2,3, ncol(smoking))] %>% 
  setNames(c("country", "year", "smoking"))

# ISO3C code
smoking <- smoking %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(iso3c)) %>% 
  select(-country) %>% 
  as_tibble

# Labelled variables
smoking <- smoking %>% 
  mutate(smoking = labelled(smoking, label = "Prevalence of daily smoking (IHME)"))


# Merge -------------------------------------------------------------------

# Joining all variables into a dataset of the dimension
risk_factors_dataset <- obesity %>% 
  full_join(bmi, by = c("iso3c", "year")) %>% 
  full_join(smoking, by = c("iso3c", "year"))

# Adding the country names and reorganizing variables
risk_factors_dataset <- risk_factors_dataset %>% 
  mutate(country = countrycode(iso3c, origin = "iso3c", destination = "country.name")) %>%
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% 
  relocate(ncol(.))

# Success message: dataset loaded
cat("\n\21 (DIM7) risk_factors_dataset (data.frame) -- successfully loaded\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects from the workspace
rm(list = ls()[!ls() %in% dataset_names])
gc()



