
source("generacion_data/00-packages.r")

source("generacion_data/01-functions.r")

# Runtime: 2 sec max.
source("generacion_data/files/dano_alcohol_dataset.r") %>% suppressWarnings

# Runtime: 1 min max.
source("generacion_data/files/ingreso_dataset.r") %>% suppressWarnings

# Runtime: 1 sec max.
source("generacion_data/files/consumo_dataset.r") %>% suppressWarnings

# source("generacion_data/04-Desigualdades/desigualdades-dataset.r")

# source("generacion_data/05-Caracteristicas-poblacion/caracteristicas-poblacion-dataset.r")

# source("generacion_data/06-Caracteristicas-ambientales/caracteristicas-ambientales-dataset.r")


# Data merge --------------------------------------------------------------

ahp_data <- dano_alcohol_dataset %>% 
  full_join(ingreso_dataset, by = c("year", "country")) %>% 
  full_join(consumo_dataset, by = c("year", "country")) %>% 



# Export ------------------------------------------------------------------

write.dta(ahp_data, "generacion_data/out/ahp_data.dta")
write.csv(ahp_data, "generacion_data/out/ahp_data.csv", row.names = FALSE)
save(ahp_data, file = "generacion_data/out/ahp_data.RData")




