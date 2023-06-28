

# Import data
population <- WDI(indicator = "NY.GDP.MKTP.CD")

# Extracting variables of interest
population <- population[,c(1,4,5)] %>% setNames(c("country", "year", "population"))

# Manually ISO3c code convert
gdp <- gdp %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled gdp variable
gdp <- gdp %>% 
  mutate(gdp = as.numeric(gdp),
         gdp = labelled(gdp, label = "Nominal GDP (current US$)"))



median_age
aged65
aged70
ext_poverty
