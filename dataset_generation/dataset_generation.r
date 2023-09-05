#!/usr/bin/Rscript

cat("\14")
rm(list = ls())

source("dataset_generation/files/00_packages.r")

source("dataset_generation/files/01_functions.r")

# Runtime: 5 sec max.
source("dataset_generation/files/02_D1_alcohol_harm_dataset.r") %>% suppressWarnings

# Runtime: 1 min max.
source("dataset_generation/files/03_D2_income_dataset.r") %>% suppressWarnings
  
# Runtime: 1 min max.
source("dataset_generation/files/04_D3_consumption_dataset.r") %>% suppressWarnings

# Runtime: 15 secs
source("dataset_generation/files/05_D4_inequalities_dataset.r") %>% suppressWarnings

# Runtime: 3 min max.
source("dataset_generation/files/06_D5_population_characteristics_dataset.r") %>% suppressWarnings

# Runtime: my work here is suspended until further notice.
# source("dataset_generation/files/07_D6_environmental_characteristics_dataset.r") %>% suppressWarnings

# Runtime: 20 seconds
source("dataset_generation/files/08_D7_risk_factors_dataset.r") %>% suppressWarnings

# # Runtime: 3 seconds
source("dataset_generation/files/09_D8_comorbidities_dataset.r") %>% suppressWarnings

# # Runtime: 11 seconds
source("dataset_generation/files/10_D9_infrastructure_dataset.r") %>% suppressWarnings

# # Runtime: 11 seconds
# source("dataset_generation/files/11_D10_public_policy_dataset.r") %>% suppressWarnings

# Data merge --------------------------------------------------------------

ahp_data <- alcohol_harm_dataset %>% 
  full_join(income_dataset, by = c("year", "country")) %>% 
  full_join(consumption_dataset, by = c("year", "country")) %>% 
  full_join(inequalities_dataset, by = c("year", "country"),
            relationship = "many-to-many") %>% 
  full_join(population_characteristics_dataset, by = c("year", "country"),
            relationship = "many-to-many") #%>% 
  # full_join(environmental_characteristics_dataset, by = c("year", "country")) %>% 
  # full_join(risk_factors_dataset, by = c("year", "country")) %>% 
  # full_join(comorbidities_dataset, by = c("year", "country"))

# ahp_data %>% 
#   arrange(country, desc(year))
# 
# ahp_data %>% names %>% cbind

# Export ------------------------------------------------------------------

write.dta(ahp_data, "dataset_generation/out/ahp_data.dta")
write.csv(ahp_data, "dataset_generation/out/ahp_data.csv", row.names = FALSE)
save(ahp_data, file = "dataset_generation/out/ahp_data.RData")


# Missings analysis -------------------------------------------------------

# Also, you can generate missings tables, with a general diagnosis, and missings by variable (year x country)
source("dataset_generation/missing_analysis/missing_gen.r")


