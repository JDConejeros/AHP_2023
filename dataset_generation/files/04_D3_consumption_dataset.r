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
apc <- filter(apc, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, NumericValue) %>% 
  setNames(c("iso3c", "year", "dim", "apc")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

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

# 11-rec_apc --------------------------------------------------------------

# Import data
rec_apc <- gho_data("SA_0000001400") 

# Select and fix variables
rec_apc <- filter(rec_apc, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, NumericValue) %>% 
  setNames(c("iso3c", "year", "dim", "rec_apc")) %>% 
  mutate(dim = recode(dim, 
                      "ALCOHOLTYPE_SA_TOTAL" = "",
                      "ALCOHOLTYPE_SA_BEER" = "_beer", 
                      "ALCOHOLTYPE_SA_SPIRITS" = "_spirits",
                      "ALCOHOLTYPE_SA_WINE" = "_wine", 
                      "ALCOHOLTYPE_SA_OTHER_ALCOHOL" = "_other")) %>% 
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
unrec_apc_3 <- gho_data("SA_0000001821_ARCHIVED") %>% filter(TimeDim == 2016)


# filter(!Id %in% c(22385153,
#                   22385154,
#                   22385323,
#                   22385346)) # 2016 2010

                                                                        
## n = 193 countries (each one)

## Omitted "SA_0000001406_ARCHIVED", "SA_0000001748", "SA_0000001748_ARCHIVED"

# Join data
unrec_apc <- unrec_apc_1 %>% 
  full_join(unrec_apc_2, by = names(.)) %>% 
  full_join(unrec_apc_3, by = names(.)) ; rm(unrec_apc_1, unrec_apc_2, unrec_apc_3)

# Extract and rename variables of interest
unrec_apc <- filter(unrec_apc, SpatialDimType == "COUNTRY" & !Id %in% c(4945420, 4945421)) %>% 
  select(SpatialDim, TimeDim, NumericValue) %>% 
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
tourist <- filter(tourist, SpatialDimType == "COUNTRY" & 
                    !Id %in% c(7570511,
                               7570512,
                               7570520,                           
                               7570558,                            
                               7570629,                            
                               7570630,
                               7570637, 
                               7570644)) %>% 
  select(SpatialDim, TimeDim, NumericValue) %>% 
  setNames(c("iso3c", "year", "tourist"))

# Labelled variables
tourist <- tourist %>% 
  mutate(tourist = labelled(tourist, label = "Tourist consumption, three-year average"))


# 14-drinkers -------------------------------------------------------------

# Import data
drinkers_1 <- gho_data("SA_0000001404") %>% select(-c(Id, Date, Comments))# 2016, 3 cat, n = 191
drinkers_2 <- gho_data("SA_0000001404_ARCHIVED") %>% select(-c(Id, Date, Comments)) # 2005, 2010, 3 cat, n = 193

drinkers_2 <- drinkers_2 %>% unique()

# Join data
drinkers <- drinkers_1 %>%
  full_join(drinkers_2, by = names(.)) ; rm(drinkers_1, drinkers_2)


# Rename variables and prepare categories
drinkers <- filter(drinkers, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, NumericValue) %>%
  setNames(c("iso3c", "year", "dim", "drinkers")) %>%
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
drinkers <- drinkers %>%
  pivot_wider(names_from = dim,
              values_from = drinkers,
              names_prefix = "drinkers") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
drinkers <- drinkers %>%
  mutate(drinkers = labelled(drinkers, label = "Drinkers only total per capita (15+ years) alcohol consumption (in litres of pure alcohol)"),
         drinkers_male = labelled(drinkers_male, label = "Drinkers only total per capita (15+ years) alcohol consumption (in litres of pure alcohol): males"),
         drinkers_female = labelled(drinkers_female, label = "Drinkers only total per capita (15+ years) alcohol consumption (in litres of pure alcohol): females"))


# 15-abstainers -----------------------------------------------------------

# Import data
abstainers_1 <- gho_data("SA_0000001409") %>% select(-c(Id, Date, Comments))
abstainers_2 <- gho_data("SA_0000001409_ARCHIVED") %>% select(-c(Id, Date, Comments))

abstainers_2 <- abstainers_2 %>% unique

## Omitted "SA_0000001409_ARCHIVED" n = 97 countries

# Join data
abstainers <- abstainers_1 %>%
  full_join(abstainers_2, by = names(.)) ; rm(abstainers_1, abstainers_2)

# Rename variables and prepare categories
abstainers <- filter(abstainers, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, Value) %>%
  setNames(c("iso3c", "year", "dim", "abstainers")) %>%
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

# Fix numeric variables
abstainers <- abstainers %>%
  mutate(abstainers = str_replace_all(abstainers, "\\s*\\[.*\\]", "") %>% as.numeric)

## Note:
## NAs are generated because in the original dataset the missing cases were recorded with the string "."


# Generar una columna para hombres y mujeres, según su categoría
abstainers <- abstainers %>%
  pivot_wider(names_from = dim,
              values_from = abstainers,
              names_prefix = "abstainers") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
abstainers <- abstainers %>%
  mutate(abstainers = labelled(abstainers, label = "Abstainers lifetime (15+ years)"),
         abstainers_male = labelled(abstainers_male, label = "Abstainers lifetime (15+ years): males"),
         abstainers_female = labelled(abstainers_female, label = "Abstainers lifetime (15+ years): females"))


# 16-absteiners_12m -------------------------------------------------------

# Import data
abstainers_12month_1 <- gho_data("SA_0000001411")
abstainers_12month_2 <- gho_data("SA_0000001411_ARCHIVED")

# Join data
abstainers_12month <- abstainers_12month_1 %>% 
  full_join(abstainers_12month_1, by = names(.)) ; rm(abstainers_12month_1, abstainers_12month_2)

# Rename variables and prepare categories
abstainers_12month <- filter(abstainers_12month, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, NumericValue) %>% 
  setNames(c("iso3c", "year", "dim", "abstainers_12month")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
abstainers_12month <- abstainers_12month %>%
  pivot_wider(names_from = dim,
              values_from = abstainers_12month,
              names_prefix = "abstainers_12month") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
abstainers_12month <- abstainers_12month %>% 
  mutate(abstainers_12month = labelled(abstainers_12month, label = "Abstainers past 12 months (%)"),
         abstainers_12month_male = labelled(abstainers_12month_male, label = "Abstainers past 12 months (%): males"),
         abstainers_12month_female = labelled(abstainers_12month_female, label = "Abstainers past 12 months (%): females"))

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
former_drinkers <- filter(former_drinkers, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, Value) %>% 
  setNames(c("iso3c", "year", "dim", "former_drinkers")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

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


# 18-consumers_12month --------------------------------------------------------

# Import data
consumers_12month_1 <- gho_data("SA_0000001413")
consumers_12month_2 <- gho_data("SA_0000001413_ARCHIVED")

# Join data
consumers_12month <- consumers_12month_1 %>% 
  full_join(consumers_12month_2, by = names(.)) ; rm(consumers_12month_1, consumers_12month_2)

# Rename variables and prepare categories
consumers_12month <- filter(consumers_12month, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, Value) %>% 
  setNames(c("iso3c", "year", "dim", "consumers_12month")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

# Generar una columna para hombres y mujeres, según su categoría
consumers_12month <- consumers_12month %>%
  pivot_wider(names_from = dim,
              values_from = consumers_12month,
              names_prefix = "consumers_12month") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
consumers_12month <- consumers_12month %>% 
  mutate(consumers_12month = labelled(consumers_12month, label = "Alcohol consumers past 12 months (%)"),
         consumers_12month_male = labelled(consumers_12month_male, label = "Alcohol consumers past 12 months (%): males"),
         consumers_12month_female = labelled(consumers_12month_female, label = "Alcohol consumers past 12 months (%): females"))


# 19-hed ------------------------------------------------------------------

# Import data
hed_1 <- gho_data("SA_0000001416")
hed_2 <- gho_data("SA_0000001416_ARCHIVED")

# Join data
hed <- hed_1 %>% 
  full_join(hed_2, by = names(.)) ; rm(hed_1, hed_2)

# Rename variables and prepare categories
hed <- filter(hed, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, Value) %>% 
  setNames(c("iso3c", "year", "dim", "hed")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

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

## Omitting "SA_0000001739_ARCHIVED" (no relevant data)

# Rename variables and prepare categories
hed_agestd <- filter(hed_agestd, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, Value) %>% 
  setNames(c("iso3c", "year", "dim", "hed_agestd")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

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



# 21-dep_12monthss ----------------------------------------------------------

# Import data
dep_12months_1 <- gho_data("SA_0000001461")
dep_12months_2 <- gho_data("SA_0000001461_ARCHIVED")

# Join data
dep_12months <- dep_12months_1 %>% 
  full_join(dep_12months_2, by = names(.)) ; rm(dep_12months_1, dep_12months_2)

# Rename variables and prepare categories
dep_12months <- dep_12months %>% 
  filter(SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, Value) %>% 
  setNames(c("iso3c", "year", "dim", "dep_12months")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

# Fix numeric variables
dep_12months <- dep_12months %>% 
  mutate(dep_12months = as.numeric(dep_12months))

# Generar una columna para hombres y mujeres, según su categoría
dep_12months <- dep_12months %>%
  pivot_wider(names_from = dim,
              values_from = dep_12months,
              names_prefix = "dep_12months") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
dep_12months <- dep_12months %>% 
  mutate(dep_12months = labelled(dep_12months, label = "Heavy episodic drinking past 30 days (%)"),
         dep_12months_male = labelled(dep_12months_male, label = "Heavy episodic drinking past 30 days (%): males"),
         dep_12months_female = labelled(dep_12months_female, label = "Heavy episodic drinking past 30 days (%): females"))


# 22-aud_12months --------------------------------------------------------------

# Import data
aud_12months_1 <- gho_data("SA_0000001462")
aud_12months_2 <- gho_data("SA_0000001462_ARCHIVED")

# Join data
aud_12months <- aud_12months_1 %>% 
  full_join(aud_12months_2, by = names(.)) ; rm(aud_12months_1, aud_12months_2)

# Rename variables and prepare categories
aud_12months <- filter(aud_12months, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, Value) %>% 
  setNames(c("iso3c", "year", "dim", "aud_12months")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

# Fix numeric variables
aud_12months <- aud_12months %>% 
  mutate(aud_12months = as.numeric(aud_12months))

# Generar una columna para hombres y mujeres, según su categoría
aud_12months <- aud_12months %>%
  pivot_wider(names_from = dim,
              values_from = aud_12months,
              names_prefix = "aud_12months") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
aud_12months <- aud_12months %>% 
  mutate(aud_12months = labelled(aud_12months, label = "Alcohol use disorders (15+), 12 month prevalence (%)"),
         aud_12months_male = labelled(aud_12months_male, label = "Alcohol use disorders (15+), 12 month prevalence (%): males"),
         aud_12months_female = labelled(aud_12months_female, label = "Alcohol use disorders (15+), 12 month prevalence (%): females"))


# 23-ahu_12months --------------------------------------------------------------

# Import data
ahu_12months_1 <- gho_data("SA_0000001754")
ahu_12months_2 <- gho_data("SA_0000001754_ARCHIVED")

# Join data
ahu_12months <- ahu_12months_1 %>% 
  full_join(ahu_12months_2, by = names(.)) ; rm(ahu_12months_1, ahu_12months_2)

# Rename variables and prepare categories
ahu_12months <- filter(ahu_12months, SpatialDimType == "COUNTRY") %>% 
  select(SpatialDim, TimeDim, Dim1, Value) %>% 
  setNames(c("iso3c", "year", "dim", "ahu_12months")) %>% 
  mutate(dim = recode(dim, "SEX_BTSX" = "", "SEX_MLE" = "_male", "SEX_FMLE" = "_female"))

# Fix numeric variables
ahu_12months <- ahu_12months %>% 
  mutate(ahu_12months = as.numeric(ahu_12months))

# Generar una columna para hombres y mujeres, según su categoría
ahu_12months <- ahu_12months %>%
  pivot_wider(names_from = dim,
              values_from = ahu_12months,
              names_prefix = "ahu_12months") %>% 
  relocate(c(1, 2:4, 5))

# Labelled variables
ahu_12months <- ahu_12months %>% 
  mutate(ahu_12months = labelled(ahu_12months, label = "Alcohol use disorders (15+), 12 month prevalence (%)"),
         ahu_12months_male = labelled(ahu_12months_male, label = "Alcohol use disorders (15+), 12 month prevalence (%): males"),
         ahu_12months_female = labelled(ahu_12months_female, label = "Alcohol use disorders (15+), 12 month prevalence (%): females"))


# Merge -------------------------------------------------------------------

# Joining all variables into a dataset of the dimension
consumption_dataset <- apc %>% 
  full_join(rec_apc, by = c("iso3c", "year")) %>% 
  full_join(unrec_apc, by = c("iso3c", "year")) %>% 
  full_join(tourist, by = c("iso3c", "year"))  %>% 
  full_join(drinkers, by = c("iso3c", "year")) %>% 
  full_join(abstainers, by = c("iso3c", "year")) %>% 
  full_join(abstainers_12month, by = c("iso3c", "year")) %>% 
  full_join(former_drinkers, by = c("iso3c", "year")) %>% 
  full_join(consumers_12month, by = c("iso3c", "year")) %>% 
  full_join(hed, by = c("iso3c", "year")) %>% 
  full_join(hed_agestd, by = c("iso3c", "year")) %>% 
  full_join(dep_12months, by = c("iso3c", "year")) %>% 
  full_join(aud_12months, by = c("iso3c", "year")) %>% 
  full_join(ahu_12months, by = c("iso3c", "year"))


# Adding the country names and reorganizing variables
consumption_dataset <- consumption_dataset %>%
  mutate(country = countrycode(iso3c, origin = "iso3c", destination = "country.name")) %>%
  mutate(iso3c = labelled(iso3c, 
                          labels = setNames(unique(iso3c), 
                                            countrycode(unique(iso3c),
                                                        origin = 'iso3c',
                                                        destination = 'country.name')),
                          label = "Country iso3c code"),
         year = labelled(year, label = "Year")) %>% relocate(ncol(.))

# Success message: dataset loaded
cat("\n\21 (DIM3) consumption_dataset (data.frame) -- successfully loaded\n\n")

# Print runtime
end = Sys.time() - start ; print(end)


# Remove objects from the workspace
rm(list = ls()[!ls() %in% dataset_names])
gc()

