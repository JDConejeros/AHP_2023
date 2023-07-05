#!/usr/bin/Rscript

# ¿Es iso3 la data de ghost?
# Investigar las diferencias entre el año 2010 en apc

start = Sys.time()


# 10-apc ------------------------------------------------------------------

# Import data
apc_1 <- gho_data("SA_0000001688") # n = 237, 2000 2005 2010 2015 2019
apc_2 <- gho_data("SA_0000001822") # n = 194 countries, 2018
apc_3 <- gho_data("SA_0000001822_ARCHIVED") # n = 194 countries, 2010 2016

apc_4 <- gho_data("SA_0000001688_ARCHIVED")

# Omitted SA_0000001688_ARCHIVED

# Join data
apc <- apc_1 %>% 
  full_join(apc_2, by = names(.)) %>% 
  full_join(filter(apc_3, TimeDim != 2010), by = names(.)) ; rm(apc_1, apc_2, apc_3)

# Rename variables and prepare categories
apc <- apc[,c(4,6,8,16)] %>% 
  setNames(c("iso3c", "year", "dim", "apc")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
apc <- apc %>%
  pivot_wider(names_from = dim,
              values_from = apc,
              names_prefix = "apc")

# ISO3C code
apc <- apc %>% 
  mutate(country = countrycode(iso3c, origin = 'iso3c', destination = 'country.name')) %>% 
  relocate(ncol(.), 1:(ncol(.)-1)) %>% 
  filter(!is.na(country)) %>% 
  select(-country) %>% 
  as_tibble

# Labelled variables
apc <- apc %>% 
  mutate(apc = labelled(apc, label = "Total per capita (15+) consumption (in litres of pure alcohol)"),
         apc_male = labelled(apc, label = "Total per capita (15+) consumption in males"),
         apc_female = labelled(apc, label = "Total per capita (15+) consumption in females"))

#Alternativa
#apc <- read.csv("generacion_data/files/data/APC_data_view_Full_Data_data.csv")

apc$Country %>% unique %>% length()
# 11-rec_apc --------------------------------------------------------------

# Import data
rec_apc <- gho_data("SA_0000001400") 

rec_apc$SpatialDim %>% unique %>% length

# Select and fix variables
rec_apc <- rec_apc[,c(4,6,8,16)] %>% 
  setNames(c("iso3c", "year", "dim", "rec_apc")) %>% 
  mutate(dim = recode(dim, 
                      "SA_TOTAL" = "",
                      "SA_BEER" = "_beer", 
                      "SA_SPIRITS" = "_spirits",
                      "SA_WINE" = "_wine", 
                      "SA_OTHER_ALCOHOL" = "_other")) %>% 
  as_tibble

# Extract species from consumption
rec_apc <- rec_apc %>%
  pivot_wider(names_from = dim,
              values_from = rec_apc,
              names_prefix = "rec_apc") %>%
  relocate(c(1,2,7,3:6)) # ponemos rec_apc (total) al principio

# Labelled data
rec_apc <- rec_apc %>% 
  mutate(rec_apc = labelled(rec_apc, label = "Recorded alcohol per capita consumption: Total"),
         rec_apc_sprits = labelled(rec_apc_spirits, label = "Recorded alcohol per capita consumption: Sprits"),
         rec_apc_wine = labelled(rec_apc_wine, label = "Recorded alcohol per capita consumption: Wine"),
         rec_apc_beer = labelled(rec_apc_beer, label = "Recorded alcohol per capita consumption: Beer"), 
         rec_apc_other = labelled(rec_apc_other, label = "Recorded alcohol per capita consumption: Other"))


# 12-unrec_apc ------------------------------------------------------------

# Import data
unrec_apc_1 <- gho_data("SA_0000001406") # 2010 2005 2015
unrec_apc_2 <- gho_data("SA_0000001821") # 2019
unrec_apc_3 <- gho_data("SA_0000001821_ARCHIVED") # 2016 2010

## n = 193 countries (each one)

## Omitted "SA_0000001406_ARCHIVED", "SA_0000001748", "SA_0000001748_ARCHIVED"

# Join data
unrec_apc <- unrec_apc_1 %>% 
  full_join(unrec_apc_2, by = names(.)) %>% 
  full_join(unrec_apc_3, by = names(.)) ; rm(unrec_apc_1, unrec_apc_2, unrec_apc_3)

# Extract and rename variables of interest
unrec_apc <- unrec_apc[,c(4,6,16)] %>% 
  setNames(c("iso3c", "year", "unrec_apc"))

# Labelled variables
unrec_apc <- unrec_apc %>% 
  mutate(unrec_apc = labelled(unrec_apc, label = "Unrecorded consumption"))


# 13-tourist --------------------------------------------------------------

# Import data
tourist_1 <- gho_data("SA_0000001405")
tourist_2 <- gho_data("SA_0000001823")
tourist_3 <- gho_data("SA_0000001823_ARCHIVED")

## n = 192 countries (each one)
## Omitted "SA_0000001405_ARCHIVED"

# Join data
tourist <- tourist_1 %>% 
  full_join(tourist_2, by = names(.)) %>% 
  full_join(filter(tourist_3, TimeDim!=2010), by = names(.)) ; rm(tourist_1, tourist_2, tourist_3)

# Extract and rename variables of interest
tourist <- tourist[,c(4,6,16)] %>% 
  setNames(c("iso3c", "year", "tourist"))

# Labelled variables
tourist <- tourist %>% 
  mutate(tourist = labelled(tourist, label = "Tourist consumption, three-year average"))


# 14-drinkers -------------------------------------------------------------

## Suspendida temporalmente

# Import data
drinkers_1 <- gho_data("SA_0000001404") # 2016, 3 cat, n = 191
drinkers_2 <- gho_data("SA_0000001404_ARCHIVED") # 2005, 2010, 3 cat, n = 193

## Por algún motivo, están duplicados algunas observaciones de drinkers2.
# drinkers_2 %>% group_by(SpatialDim, Dim1) %>% count(TimeDim) %>% View()

# Join data
drinkers <- drinkers_1 %>%
  full_join(drinkers_2, by = names(.)) ; rm(drinkers_1, drinkers_2)

# Rename variables and prepare categories
drinkers <- drinkers[,c(4,6,8,16)] %>%
  setNames(c("iso3c", "year", "dim", "drinkers")) %>%
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
drinkers <- drinkers %>%
  pivot_wider(names_from = dim,
              values_from = drinkers,
              names_prefix = "drinkers",
              values_fn = {mean}) %>% # Cambiar esto
  relocate(c(1, 2:4, 5))

# Labelled variables
drinkers <- drinkers %>%
  mutate(drinkers = labelled(drinkers, label = "Drinkers only total per capita (15+ years) alcohol consumption (in litres of pure alcohol)"),
         drinkers_male = labelled(drinkers_male, label = "Drinkers only total per capita (15+ years) alcohol consumption (in litres of pure alcohol): males"),
         drinkers_female = labelled(drinkers_female, label = "Drinkers only total per capita (15+ years) alcohol consumption (in litres of pure alcohol): females"))


# 15-abstainers -----------------------------------------------------------

# Import data
abstainers_1 <- gho_data("SA_0000001409")
abstainers_2 <- gho_data("SA_0000001409_ARCHIVED")

## Omitted "SA_0000001409_ARCHIVED" n = 97 countries

# Join data
abstainers <- abstainers_1 %>%
  full_join(abstainers_2, by = names(.)) ; rm(abstainers_1, abstainers_2)

# Rename variables and prepare categories
abstainers <- abstainers[,c(4,6,8,15)] %>%
  setNames(c("iso3c", "year", "dim", "abstainers")) %>%
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"),
         abstainers = as.numeric(abstainers))

# Fix numeric variables
abstainers <- abstainers %>%
  mutate(abstainers = str_replace_all(abstainers, "\\s*\\[.*\\]", "") %>% as.numeric)

# Generar una columna para hombres y mujeres, según su categoría
abstainers <- abstainers %>%
  pivot_wider(names_from = dim,
              values_from = abstainers,
              names_prefix = "abstainers",
              values_fn = {mean}) %>% # Cambiar esto ------
  relocate(c(1, 2:4, 5))

# Labelled variables
abstainers <- abstainers %>%
  mutate(abstainers = labelled(abstainers, label = "Abstainers lifetime (15+ years)"),
         abstainers_male = labelled(abstainers_male, label = "Abstainers lifetime (15+ years): males"),
         abstainers_female = labelled(abstainers_female, label = "Abstainers lifetime (15+ years): females"))


# 16-absteiners_12m -------------------------------------------------------

# Import data
abstainers_12m_1 <- gho_data("SA_0000001411")
abstainers_12m_2 <- gho_data("SA_0000001411_ARCHIVED")

# Join data
abstainers_12m <- abstainers_12m_1 %>% 
  full_join(abstainers_12m_1, by = names(.)) ; rm(abstainers_12m_1, abstainers_12m_1)

# Rename variables and prepare categories
abstainers_12m <- abstainers_12m[,c(4,6,8,16)] %>% 
  setNames(c("iso3c", "year", "dim", "abstainers_12m")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
abstainers_12m <- abstainers_12m %>%
  pivot_wider(names_from = dim,
              values_from = abstainers_12m,
              names_prefix = "abstainers_12m") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
abstainers_12m <- abstainers_12m %>% 
  mutate(abstainers_12m = labelled(abstainers_12m, label = "Abstainers past 12 months (%)"),
         abstainers_12m_male = labelled(abstainers_12m_male, label = "Abstainers past 12 months (%): males"),
         abstainers_12m_female = labelled(abstainers_12m_female, label = "Abstainers past 12 months (%): females"))


# 17-former_drinkers ------------------------------------------------------

# Import data
former_drinkers_1 <- gho_data("SA_0000001414")
former_drinkers_2 <- gho_data("SA_0000001414_ARCHIVED")

# Resolving data inconsistencies
former_drinkers_1 <- former_drinkers_1 %>% 
  select(-"NumericValue") %>% 
  mutate(Value = as.numeric(Value))

former_drinkers_2 <- former_drinkers_2 %>% 
  select(-"Value") %>% 
  rename("Value"="NumericValue") %>% 
  mutate(Value = as.numeric(Value))

# Join data
former_drinkers <- former_drinkers_1 %>% 
  full_join(former_drinkers_2, by = names(.)) ; rm(former_drinkers_1, former_drinkers_2)

# Rename variables and prepare categories
former_drinkers <- former_drinkers[,c(4,6,8,15)] %>% 
  setNames(c("iso3c", "year", "dim", "former_drinkers")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
former_drinkers <- former_drinkers %>%
  pivot_wider(names_from = dim,
              values_from = former_drinkers,
              names_prefix = "former_drinkers") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
former_drinkers <- former_drinkers %>% 
  mutate(former_drinkers = labelled(former_drinkers, label = "Former drinkers (%)"),
         former_drinkers_male = labelled(former_drinkers_male, label = "Former drinkers (%): males"),
         former_drinkers_female = labelled(former_drinkers_female, label = "Former drinkers (%): females"))

# 18-consumers_12m --------------------------------------------------------

# Import data
consumers_12m_1 <- gho_data("SA_0000001413")
consumers_12m_2 <- gho_data("SA_0000001413_ARCHIVED")

# Join data
consumers_12m <- consumers_12m_1 %>% 
  full_join(consumers_12m_2, by = names(.)) ; rm(consumers_12m_1, consumers_12m_2)

# Rename variables and prepare categories
consumers_12m <- consumers_12m[,c(4,6,8,15)] %>% 
  setNames(c("iso3c", "year", "dim", "consumers_12m")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
consumers_12m <- consumers_12m %>%
  pivot_wider(names_from = dim,
              values_from = consumers_12m,
              names_prefix = "consumers_12m") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
consumers_12m <- consumers_12m %>% 
  mutate(consumers_12m = labelled(consumers_12m, label = "Alcohol consumers past 12 months (%)"),
         consumers_12m_male = labelled(consumers_12m_male, label = "Alcohol consumers past 12 months (%): males"),
         consumers_12m_female = labelled(consumers_12m_female, label = "Alcohol consumers past 12 months (%): females"))

# 19-hed ------------------------------------------------------------------

# Import data
hed_1 <- gho_data("SA_0000001416")
hed_2 <- gho_data("SA_0000001416_ARCHIVED")

# Join data
hed <- hed_1 %>% 
  full_join(hed_2, by = names(.)) ; rm(hed_1, hed_2)

# Rename variables and prepare categories
hed <- hed[,c(4,6,8,16)] %>% 
  setNames(c("iso3c", "year", "dim", "hed")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
hed <- hed %>%
  pivot_wider(names_from = dim,
              values_from = hed,
              names_prefix = "hed") %>% 
  relocate(c(1, 2:4, 5))


# Labelled variables
hed <- hed %>% 
  mutate(hed = labelled(hed, label = "Heavy episodic drinking past 30 days (%)"),
         hed_male = labelled(hed_male, label = "Heavy episodic drinking past 30 days (%): males"),
         hed_female = labelled(hed_female, label = "Heavy episodic drinking past 30 days (%): females"))


# 20-hed_agestd -----------------------------------------------------------

# Import data
hed_agestd <- gho_data("SA_0000001739")
# hed_agestd_2 <- gho_data("SA_0000001739_ARCHIVED")

## Omitting "SA_0000001739_ARCHIVED" (no relevant data)

# Join data
# hed_agestd <- hed_agestd_1 %>% 
#   full_join(hed_agestd_2, by = names(.))

# Rename variables and prepare categories
hed_agestd <- hed_agestd[,c(4,6,8,16)] %>% 
  setNames(c("iso3c", "year", "dim", "hed_agestd")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
hed_agestd <- hed_agestd %>%
  pivot_wider(names_from = dim,
              values_from = hed_agestd,
              names_prefix = "hed_agestd") %>% 
  relocate(c(1, 2:4, 5))


# Labelled variables
hed_agestd <- hed_agestd %>% 
  mutate(hed_agestd = labelled(hed_agestd, label = "Heavy episodic drinking past 30 days (%)"),
         hed_agestd_male = labelled(hed_agestd_male, label = "Heavy episodic drinking past 30 days (%): males"),
         hed_agestd_female = labelled(hed_agestd_female, label = "Heavy episodic drinking past 30 days (%): females"))


# 21-dep_12months ----------------------------------------------------------

# Import data
ad_12m_1 <- gho_data("SA_0000001461")
ad_12m_2 <- gho_data("SA_0000001461_ARCHIVED")

# Join data
ad_12m <- ad_12m_1 %>% 
  full_join(ad_12m_2, by = names(.)) ; rm(ad_12m_1, ad_12m_2)

# Rename variables and prepare categories
ad_12m <- ad_12m[,c(4,6,8,15)] %>% 
  setNames(c("iso3c", "year", "dim", "ad_12m")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Fix numeric variables
ad_12m <- ad_12m %>% 
  mutate(ad_12m = str_replace_all(ad_12m, "\\s*\\[.*\\]", "") %>% as.numeric)

# Generar una columna para hombres y mujeres, según su categoría
ad_12m <- ad_12m %>%
  pivot_wider(names_from = dim,
              values_from = ad_12m,
              names_prefix = "ad_12m") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
ad_12m <- ad_12m %>% 
  mutate(ad_12m = labelled(ad_12m, label = "Heavy episodic drinking past 30 days (%)"),
         ad_12m_male = labelled(ad_12m_male, label = "Heavy episodic drinking past 30 days (%): males"),
         ad_12m_female = labelled(ad_12m_female, label = "Heavy episodic drinking past 30 days (%): females"))


# 22-aud_12m --------------------------------------------------------------

# Import data
aud_12m_1 <- gho_data("SA_0000001462")
aud_12m_2 <- gho_data("SA_0000001462_ARCHIVED")

# Join data
aud_12m <- aud_12m_1 %>% 
  full_join(aud_12m_2, by = names(.)) ; rm(aud_12m_1, aud_12m_2)

# Rename variables and prepare categories
aud_12m <- aud_12m[,c(4,6,8,15)] %>% 
  setNames(c("iso3c", "year", "dim", "aud_12m")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Fix numeric variables
aud_12m <- aud_12m %>% 
  mutate(aud_12m = str_replace_all(aud_12m, "\\s*\\[.*\\]", "") %>% as.numeric)

# Generar una columna para hombres y mujeres, según su categoría
aud_12m <- aud_12m %>%
  pivot_wider(names_from = dim,
              values_from = aud_12m,
              names_prefix = "aud_12m") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
aud_12m <- aud_12m %>% 
  mutate(aud_12m = labelled(aud_12m, label = "Alcohol use disorders (15+), 12 month prevalence (%)"),
         aud_12m_male = labelled(aud_12m_male, label = "Alcohol use disorders (15+), 12 month prevalence (%): males"),
         aud_12m_female = labelled(aud_12m_female, label = "Alcohol use disorders (15+), 12 month prevalence (%): females"))

# 23-ahu_12m --------------------------------------------------------------

# Import data
ahu_12m_1 <- gho_data("SA_0000001754")
ahu_12m_2 <- gho_data("SA_0000001754_ARCHIVED")

# Join data
ahu_12m <- ahu_12m_1 %>% 
  full_join(ahu_12m_2, by = names(.)) ; rm(ahu_12m_1, ahu_12m_2)

# Rename variables and prepare categories
ahu_12m <- ahu_12m[,c(4,6,8,15)] %>% 
  setNames(c("iso3c", "year", "dim", "ahu_12m")) %>% 
  mutate(dim = recode(dim, "BTSX" = "", "MLE" = "_male", "FMLE" = "_female"))

# Fix numeric variables
ahu_12m <- ahu_12m %>% 
  mutate(ahu_12m = str_replace_all(ahu_12m, "\\s*\\[.*\\]", "") %>% as.numeric)

# Generar una columna para hombres y mujeres, según su categoría
ahu_12m <- ahu_12m %>%
  pivot_wider(names_from = dim,
              values_from = ahu_12m,
              names_prefix = "ahu_12m") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
ahu_12m <- ahu_12m %>% 
  mutate(ahu_12m = labelled(ahu_12m, label = "Alcohol use disorders (15+), 12 month prevalence (%)"),
         ahu_12m_male = labelled(ahu_12m_male, label = "Alcohol use disorders (15+), 12 month prevalence (%): males"),
         ahu_12m_female = labelled(ahu_12m_female, label = "Alcohol use disorders (15+), 12 month prevalence (%): females"))


# Merge -------------------------------------------------------------------

consumption_dataset <- apc %>% 
  full_join(rec_apc, by = c("iso3c", "year")) %>% 
  full_join(unrec_apc, by = c("iso3c", "year")) %>% 
  full_join(tourist, by = c("iso3c", "year"))  %>% 
  full_join(drinkers, by = c("iso3c", "year")) %>% 
  full_join(abstainers, by = c("iso3c", "year")) %>% 
  full_join(abstainers_12m, by = c("iso3c", "year")) %>% 
  full_join(former_drinkers, by = c("iso3c", "year")) %>% 
  full_join(consumers_12m, by = c("iso3c", "year")) %>% 
  full_join(hed, by = c("iso3c", "year")) %>% 
  full_join(hed_agestd, by = c("iso3c", "year")) %>% 
  full_join(ad_12m, by = c("iso3c", "year")) %>% 
  full_join(aud_12m, by = c("iso3c", "year")) %>% 
  full_join(ahu_12m, by = c("iso3c", "year"))


# iso3c --> country
consumption_dataset <- consumption_dataset %>% 
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% 
  rename("country" = "iso3c")

# Success message!
cat("\n\21 consumption_dataset -- successfully loaded\n\n")

# Print runtime
end = Sys.time() - start ; print(end)


# Remove objects
rm(list = ls()[!ls() %in% c("alcohol_harm_dataset", "income_dataset", "consumption_dataset")])

