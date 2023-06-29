
source("generacion_data/files/00_packages.r")

source("generacion_data/files/01_functions.r")

# Runtime: 2 sec max.
source("generacion_data/files/02_D1_alcohol_harm_dataset.r") %>% suppressWarnings

# Runtime: 1 min max.
source("generacion_data/files/03_D2_income_dataset.r") %>% suppressWarnings

# Runtime: 1 min max.
source("generacion_data/files/04_D3_consumption_dataset.r") %>% suppressWarnings

# Runtime: ??
source("generacion_data/files/05_D4_inequalities_dataset.r")

# Runtime: ??
source("generacion_data/files/06_D5_population_characteristics_dataset.r")

# Runtime: ??
source("generacion_data/files/07_D6_environmental_characteristics_dataset.r")

# Runtime: ??
source("generacion_data/files/08_D7_risk_factors_dataset.r")

# Runtime: ??
source("generacion_data/files/09_D8_comorbidities_dataset.r")

# Data merge --------------------------------------------------------------

ahp_data <- dano_alcohol_dataset %>% 
  full_join(ingreso_dataset, by = c("year", "country")) %>% 
  full_join(consumo_dataset, by = c("year", "country"))

# Export ------------------------------------------------------------------

write.dta(ahp_data, "generacion_data/out/ahp_data.dta")
write.csv(ahp_data, "generacion_data/out/ahp_data.csv", row.names = FALSE)
save(ahp_data, file = "generacion_data/out/ahp_data.RData")




