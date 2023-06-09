#!/usr/bin/Rscript

start = Sys.time()


# 27-population -----------------------------------------------------------
population <- WDI(indicator = "NY.GDP.MKTP.CD")

population <- population[,c(1,4,5)] %>% setNames(c("country", "year", "population"))

# Manually ISO3c code convert
population <- population %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled population variable
population <- population %>% 
  mutate(population = as.numeric(population),
         population = labelled(population, label = "Population"))

# 28-median_age -----------------------------------------------------------
median_age <- owid(chart_id = "median-age")

median_age <- median_age[,c(1, 3, 4)] %>% 
  setNames(c("country", "year", "median_age"))

# Manually ISO3c code convert
median_age <- median_age %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled median_age variable
median_age <- median_age %>% 
  mutate(median_age = as.numeric(median_age),
         median_age = labelled(median_age, label = "Median age of population"))

# 29-aged65 ---------------------------------------------------------------
aged65 <- WDI(indicator = "SP.POP.65UP.TO.ZS")

aged65 <- aged65[,c(1,4,5)] %>% setNames(c("country", "year", "aged65"))

# Manually ISO3c code convert
aged65 <- aged65 %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled aged 65 population variable
aged65 <- aged65 %>% 
  mutate(aged65 = as.numeric(aged65),
         aged65 = labelled(aged65, label = "Population ages 65 and above (%  population)"))

# 30-aged70 ---------------------------------------------------------------
aged70_male <- WDI(indicator = "SP.POP.7074.MA.5Y")

aged70_male <- aged70_male[,c(1,4,5)] %>% 
  setNames(c("country", "year", "aged70_male"))

# Manually ISO3c code convert
aged70_male <- aged70_male %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled aged70_male variable
aged70_male <- aged70_male %>% 
  mutate(aged70_male = as.numeric(aged70_male),
         aged70_male = labelled(aged70_male, label = "Population ages 70-74 males (% of male population)"))


# males
aged70_female <- WDI(indicator = "SP.POP.7074.FE.5Y")

aged70_female <- aged70_female[,c(1,4,5)] %>% 
  setNames(c("country", "year", "aged70_female"))

# Manually ISO3c code convert
aged70_female <- aged70_female %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled aged70_female variable
aged70_female <- aged70_female %>% 
  mutate(aged70_female = as.numeric(aged70_female),
         aged70_female = labelled(aged70_female, label = "Population ages 70-74 females (% of female population)"))



# 31-ext_poverty ----------------------------------------------------------
ext_poverty <- owid(chart_id = "share-of-population-in-extreme-poverty")

ext_poverty <- ext_poverty[,c(1, 3, 4)] %>% 
  setNames(c("country", "year", "ext_poverty"))

# Manually ISO3c code convert
ext_poverty <- ext_poverty %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled ext_poverty variable
ext_poverty <- ext_poverty %>% 
  mutate(ext_poverty = as.numeric(ext_poverty),
         ext_poverty = labelled(ext_poverty, label = "Share of population living in extreme poverty"))


# 32-life_expectancy ------------------------------------------------------
life_expectancy <- WDI(indicator = "SP.DYN.LE00.IN")

life_expectancy <- life_expectancy[,c(1,4,5)] %>% 
  setNames(c("country", "year", "life_expectancy"))

# Manually ISO3c code convert
life_expectancy <- life_expectancy %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled life_expectancy variable
life_expectancy <- life_expectancy %>% 
  mutate(life_expectancy = as.numeric(life_expectancy),
         life_expectancy = labelled(life_expectancy, label = "Life expectancy at birth, total (years)"))

# 33-schooling ------------------------------------------------------------
schooling <- owid(chart_id = "expected-years-of-schooling")

schooling <- schooling[,c(1, 3, 4)] %>% 
  setNames(c("country", "year", "schooling"))

# Manually ISO3c code convert
schooling <- schooling %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled schooling variable
schooling <- schooling %>% 
  mutate(schooling = as.numeric(schooling),
         schooling = labelled(schooling, label = "Expected years of schooling, 2021"))

## ALTERNATIVES AVIABLE ** -----------

# 34-literacy -------------------------------------------------------------
literacy <- WDI(indicator = "SE.ADT.LITR.ZS")

literacy <- literacy[,c(1,4,5)] %>% 
  setNames(c("country", "year", "literacy"))

# Manually ISO3c code convert
literacy <- literacy %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', 
                             destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled literacy variable
literacy <- literacy %>% 
  mutate(literacy = as.numeric(literacy),
         literacy = labelled(literacy, label = "Literacy rate, adult total (% of people ages 15 and above)"))

# 35-urban ----------------------------------------------------------------
urban <- WDI(indicator = "SP.URB.TOTL.IN.ZS")

urban <- urban[,c(1,4,5)] %>% 
  setNames(c("country", "year", "urban"))

# Manually ISO3c code convert
urban <- urban %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', 
                             destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled urban rate variable
urban <- urban %>% 
  mutate(urban = as.numeric(urban),
         urban = labelled(urban, label = "Urban population (% of total population)"))

# 36-dependency -----------------------------------------------------------
dependency <- WDI(indicator = "SP.POP.DPND")

dependency <- dependency[,c(1,4,5)] %>% 
  setNames(c("country", "year", "dependency"))

# Manually ISO3c code convert
dependency <- dependency %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled dependency variable
dependency <- dependency %>% 
  mutate(dependency = as.numeric(dependency),
         dependency = labelled(dependency, label = "Age dependency ratio (% of working-age population)"))

# 37-homicide -------------------------------------------------------------
homicide <- WDI(indicator = "VC.IHR.PSRC.P5")

homicide <- homicide[,c(1,4,5)] %>% 
  setNames(c("country", "year", "homicide"))

# Manually ISO3c code convert
homicide <- homicide %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled homicide variable
homicide <- homicide %>% 
  mutate(homicide = as.numeric(homicide),
         homicide = labelled(homicide, label = "Intentional homicides (per 100,000 people)"))

## Alternative: https://ourworldindata.org/grapher/intentional-homicides-per-100000-people?tab=chart ----

# 38-net_migration --------------------------------------------------------
net_migration <- WDI(indicator = "SM.POP.NETM")

net_migration <- net_migration[,c(1,4,5)] %>% 
  setNames(c("country", "year", "net_migration"))

# Manually ISO3c code convert
net_migration <- net_migration %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', 
                                     destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled net_migration variable
net_migration <- net_migration %>% 
  mutate(net_migration = as.numeric(net_migration),
         net_migration = labelled(net_migration, label = "Net migration"))

# 39-hdi ------------------------------------------------------------------
hdi <- owid(chart_id = "human-development-index")

hdi <- hdi[,c(1, 3, 4)] %>% 
  setNames(c("country", "year", "hdi"))

# Manually ISO3c code convert
hdi <- hdi %>% 
  mutate(iso3c = countrycode(country, origin = 'country.name', 
                             destination = 'iso3c')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  select(-country) %>% 
  as_tibble %>% 
  filter(!is.na(iso3c))

# Labelled hdi variable
hdi <- hdi %>% 
  mutate(hdi = as.numeric(hdi),
         hdi = labelled(hdi, label = "Human Development Index, 2021"))

# 40-high_blood_glucose ---------------------------------------------------
# pendiente

# 41-high_blood_pressure --------------------------------------------------
# pendiente


# Merge -------------------------------------------------------------------

population_characteristics_dataset <- population %>% 
  full_join(median_age, by = c("iso3c", "year")) %>% 
  full_join(aged65, by = c("iso3c", "year")) %>% 
  full_join(aged70_male, by = c("iso3c", "year")) %>% 
  full_join(aged70_female, by = c("iso3c", "year")) %>% 
  full_join(ext_poverty, by = c("iso3c", "year")) %>% 
  full_join(life_expectancy, by = c("iso3c", "year")) %>% 
  full_join(schooling, by = c("iso3c", "year")) %>% 
  full_join(literacy, by = c("iso3c", "year")) %>% 
  full_join(urban, by = c("iso3c", "year")) %>% 
  full_join(dependency, by = c("iso3c", "year")) %>% 
  full_join(homicide, by = c("iso3c", "year")) %>% 
  full_join(net_migration, by = c("iso3c", "year")) %>% 
  full_join(hdi, by = c("iso3c", "year"))


# Lablled country data
population_characteristics_dataset <- population_characteristics_dataset %>% 
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% 
  rename("country" = "iso3c")

# Success message!
cat("\n\21 (DIM5) dataset population_characteristics_dataset -- successfully loaded\n\n\n")

# Print runtime
end = Sys.time() - start ; print(end)

# Remove objects
rm(list = ls()[!ls() %in% c("alcohol_harm_dataset", "income_dataset", "consumption_dataset",
                            "inequalities_dataset", "population_characteristics_dataset")])


