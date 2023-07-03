
dano_oh <- read.csv("files/data/IHME-GBD_2019_DATA-ff885ce3-1/IHME-GBD_2019_DATA-ff885ce3-1.csv")  %>% tibble

# deaths ------------------------------------------------------------------

deaths <- dano_oh %>% filter(measure_name == "Deaths")
deaths %>% names %>% cbind

deaths <- deaths[,c(4,13, 12, 6, 14)] %>% 
  setNames(c("country", "year", "dim1", "dim2", "deaths")) %>% 
  pivot_wider(names_from = c(dim1, dim2),
              values_from = deaths,
              names_prefix = "deaths")

deaths <- deaths %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble


# for loop
deaths <- deaths %>% 
  mutate(
    deathsNumber_Male = labelled(deathsNumber_Male , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use: Males"),
    deathsNumber_Female = labelled(deathsNumber_Female , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use: Females"),
    deathsNumber_Both = labelled(deathsNumber_Both , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use"),
    deathsPercent_Male = labelled(deathsPercent_Male , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Males"),
    deathsPercent_Female = labelled(deathsPercent_Female , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Females"),
    deathsPercent_Both = labelled(deathsPercent_Both , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Percent)"),
    deathsRate_Male = labelled(deathsRate_Male , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Males"),
    deathsRate_Female = labelled(deathsRate_Female , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Females"),
    deathsRate_Both = labelled(deathsRate_Both , label = "Deaths for Cirrhosis and other chronic liver diseases due to alcohol use (Rate)")
  )

# prevalence --------------------------------------------------------------

prevalence <- dano_oh  %>% filter(measure_name == "Prevalence")

prevalence <- prevalence[,c(4,13, 12, 6, 14)] %>% 
  setNames(c("country", "year", "dim1", "dim2", "prevalence")) %>% 
  pivot_wider(names_from = c(dim1, dim2),
              values_from = prevalence,
              names_prefix = "prevalence")

prevalence <- prevalence %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble


# for loop
prevalence <- prevalence %>% 
  mutate(
    prevalenceNumber_Male = labelled(prevalenceNumber_Male , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use: Males"),
    prevalenceNumber_Female = labelled(prevalenceNumber_Female , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use: Females"),
    prevalenceNumber_Both = labelled(prevalenceNumber_Both , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use"),
    prevalencePercent_Male = labelled(prevalencePercent_Male , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Males"),
    prevalencePercent_Female = labelled(prevalencePercent_Female , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Females"),
    prevalencePercent_Both = labelled(prevalencePercent_Both , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Percent)"),
    prevalenceRate_Male = labelled(prevalenceRate_Male , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Males"),
    prevalenceRate_Female = labelled(prevalenceRate_Female , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Females"),
    prevalenceRate_Both = labelled(prevalenceRate_Both , label = "Prevalence of Cirrhosis and other chronic liver diseases due to alcohol use (Rate)")
  )


# incidence ---------------------------------------------------------------

incidence <- dano_oh  %>% filter(measure_name == "Incidence")

incidence <- incidence <- incidence[,c(4,13, 12, 6, 14)] %>% 
  setNames(c("country", "year", "dim1", "dim2", "incidence")) %>% 
  pivot_wider(names_from = c(dim1, dim2),
              values_from = incidence,
              names_prefix = "incidence")

incidence <- incidence %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble


# for loop
incidence <- incidence %>% 
  mutate(
    incidenceNumber_Male = labelled(incidenceNumber_Male , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use: Males"),
    incidenceNumber_Female = labelled(incidenceNumber_Female , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use: Females"),
    incidenceNumber_Both = labelled(incidenceNumber_Both , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use"),
    incidencePercent_Male = labelled(incidencePercent_Male , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Males"),
    incidencePercent_Female = labelled(incidencePercent_Female , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Percent): Females"),
    incidencePercent_Both = labelled(incidencePercent_Both , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Percent)"),
    incidenceRate_Male = labelled(incidenceRate_Male , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Rate) : Males"),
    incidenceRate_Female = labelled(incidenceRate_Female , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Rate): Females"),
    incidenceRate_Both = labelled(incidenceRate_Both , label = "Incidence Cirrhosis and other chronic liver diseases due to alcohol use (Rate)"),
  )

# unir base de datos

dano_alcohol_dataset <- deaths %>% 
  full_join(prevalence, by = c("iso3c", "year")) %>% 
  full_join(incidence, by = c("iso3c", "year")) 
  

## Revisar esto
dano_alcohol_dataset <- dano_alcohol_dataset %>% 
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% 
  rename("country" = "iso3c")

# Success message!
cat("\n\3 Cargado con éxito: (data.frame)  dano_alcohol_dataset\n")

# Print runtime
end = Sys.time() - start ; print(end)
