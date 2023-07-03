
setwd("dataset_generation")

source("files/00_packages.r")

source("files/01_functions.r")

# Runtime: 2 sec max.
source("files/02_D1_alcohol_harm_dataset.r") %>% suppressWarnings

# Runtime: 1 min max.
source("files/03_D2_income_dataset.r") %>% suppressWarnings

# Runtime: 1 min max.
source("files/04_D3_consumption_dataset.r") %>% suppressWarnings

# Runtime: 15 secs
source("files/05_D4_inequalities_dataset.r") %>% suppressWarnings

# Runtime: ??
source("files/06_D5_population_characteristics_dataset.r")

# Runtime: ??
source("files/07_D6_environmental_characteristics_dataset.r")

# Runtime: ??
source("files/08_D7_risk_factors_dataset.r")

# Runtime: ??
source("files/09_D8_comorbidities_dataset.r")

# Data merge --------------------------------------------------------------

ahp_data <- dano_alcohol_dataset %>% 
  full_join(ingreso_dataset, by = c("year", "country")) %>% 
  full_join(consumo_dataset, by = c("year", "country")) %>% 
  full_join(inequalities_dataset, by = c("year", "country"))

View(ahp_data)
ahp_data %>% names %>% cbind

# Export ------------------------------------------------------------------

write.dta(ahp_data, "out/ahp_data.dta")
write.csv(ahp_data, "out/ahp_data.csv", row.names = FALSE)
save(ahp_data, file = "out/ahp_data.RData")




