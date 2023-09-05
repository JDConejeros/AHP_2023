#!/usr/bin/Rscript

start = Sys.time()

dano_oh <- read.csv("dataset_generation/files/data/IHME-GBD_2019_DATA-ff885ce3-1/IHME-GBD_2019_DATA-ff885ce3-1.csv")  %>% tibble

# deaths ------------------------------------------------------------------

# Filter the 'dano_oh' dataset to extract Deaths
deaths <- dano_oh %>% filter(measure_name == "Deaths")

# Select and rename columns
deaths <- deaths[, c(4, 13, 11, 5, 14)] %>%
  setNames(c("country", "year", "dim1", "dim2", "deaths")) %>%
  mutate(dim1 = recode(dim1, "3" = "", "1" = "M", "2" = "F"),
         dim2 = recode(dim2, "1" = "", "2" = "_percent", "3" = "_rate")) %>%
  pivot_wider(names_from = c(dim2, dim1),
              values_from = deaths,
              names_prefix = "deaths",
              names_glue = "{.value}{dim2}{dim1}") %>%
  relocate(1:2, ncol(.) - 2, ncol(.) - 1, ncol(.))


# Convert country names to ISO3C codes
deaths <- deaths %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(iso3c)) %>% 
  select(-country)


# Add labels to variables
deaths <- deaths %>% 
  mutate(
    deathsM = labelled(deathsM , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use: Males"),
    deathsF = labelled(deathsF , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use: Females"),
    deaths = labelled(deaths , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use"),
    deaths_percentM = labelled(deaths_percentM , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Males"),
    deaths_percentF = labelled(deaths_percentF , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Females"),
    deaths_percent = labelled(deaths_percent , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Percent)"),
    deaths_rateM = labelled(deaths_rateM , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Males"),
    deaths_rateF = labelled(deaths_rateF , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Females"),
    deaths_rate = labelled(deaths_rate , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Rate)")
  )

# prevalence --------------------------------------------------------------

# Importing the dataset and filtering for "Prevalence" measure
prevalence <- dano_oh  %>% filter(measure_name == "Prevalence")

# Selecting specific columns and restructure the data to a wider format
prevalence <- prevalence[,c(4,13, 11, 5, 14)] %>% 
  setNames(c("country", "year", "dim1", "dim2", "prevalence")) %>%
  mutate(dim1 = recode(dim1, "3" = "", "1" = "M", "2" = "F"),
         dim2 = recode(dim2, "1" = "", "2" = "_percent", "3" = "_rate")) %>% 
  pivot_wider(names_from = c(dim2, dim1),
              values_from = prevalence,
              names_prefix = "prevalence",
              names_glue = "{.value}{dim2}{dim1}") %>% 
  relocate(1:2, ncol(.)-2, ncol(.)-1, ncol(.))

# Convert country names to ISO3C codes
prevalence <- prevalence %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(iso3c)) %>% 
  select(-country)

# Add labels to variables
prevalence <- prevalence %>% 
  mutate(
    prevalenceM = labelled(prevalenceM , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use: Males"),
    prevalenceF = labelled(prevalenceF , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use: Females"),
    prevalence = labelled(prevalence , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use"),
    prevalence_percentM = labelled(prevalence_percentM , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Males"),
    prevalence_percentF = labelled(prevalence_percentF , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Females"),
    prevalence_percent = labelled(prevalence_percentM , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Percent)"),
    prevalence_rateM = labelled(prevalence_rateM , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Males"),
    prevalence_rateF = labelled(prevalence_rateF , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Females"),
    prevalence_rate = labelled(prevalence_rate , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Rate)")
  )


# incidence ---------------------------------------------------------------

# Importing the dataset and filtering for "Incidence" measure
incidence <- dano_oh  %>% filter(measure_name == "Incidence")

# Selecting specific columns and restructure the data to a wider format
incidence <- incidence[,c(4,13, 11, 5, 14)] %>% 
  setNames(c("country", "year", "dim1", "dim2", "incidence")) %>%
  mutate(dim1 = recode(dim1, "3" = "", "1" = "M", "2" = "F"),
         dim2 = recode(dim2, "1" = "", "2" = "_percent", "3" = "_rate")) %>% 
  pivot_wider(names_from = c(dim2, dim1),
              values_from = incidence,
              names_prefix = "incidence",
              names_glue = "{.value}{dim2}{dim1}") %>% 
  relocate(1:2, ncol(.)-2, ncol(.)-1, ncol(.))

# Convert country names to ISO3C codes
incidence <- incidence %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(iso3c)) %>% 
  select(-country)


# Add labels to variables
incidence <- incidence %>% 
  mutate(
    incidenceM = labelled(incidenceM , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use: Males"),
    incidenceF = labelled(incidenceF , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use: Females"),
    incidence = labelled(incidence , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use"),
    incidence_percentM = labelled(incidence_percentM , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Males"),
    incidence_percentF = labelled(incidence_percentF , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Females"),
    incidence_percent = labelled(incidence_percent , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Percent)"),
    incidence_rateM = labelled(incidence_rateM , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Rate) : Males"),
    incidence_rateF = labelled(incidence_rateF , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Females"),
    incidence_rate = labelled(incidence_rate , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Rate)"),
  )


# Merge variables ---------------------------------------------------------

# Joining all variables into a dataset of the dimension
alcohol_harm_dataset <- deaths %>% 
  full_join(prevalence, by = c("iso3c", "year")) %>% 
  full_join(incidence, by = c("iso3c", "year")) 


# Adding the country names and reorganizing variable
alcohol_harm_dataset <- alcohol_harm_dataset %>% 
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
cat("\n\21 (DIM1) alcohol_harm_dataset (data.frame) -- successfully loaded\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects from the workspace
rm(list = ls()[!ls() %in% dataset_names])
gc()
