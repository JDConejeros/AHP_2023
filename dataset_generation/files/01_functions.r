
## Quizás no se anecesario tener este apartado

# Función
is.serie <- function(serie) {
  
  condicion_verificada <- any(sort(unique(serie)) == (1:length(unique(serie)) + min(serie) - 1))
  
  if (length(unique(serie)) == length(min(serie):max(serie))) {
    return(paste0("Serie sin discontinuidades: ", min(serie), "-", max(serie)))
  } else {
    return("Hay discontinuidades") # Sería genial desarrollar un bucle for que vaya detectando las discontinuidades y arme el string de las secuencias...
  }
}


# Dataset names values
dataset_names <- c("dataset_names", "na_count", "globalSummary",
                     "alcohol_harm_dataset", "income_dataset", "consumption_dataset",
                     "inequalities_dataset", "population_characteristics_dataset", 
                     "environmental_characteristics_dataset", "risk_factors_dataset", 
                     "comorbidities_dataset", "infrastructure_dataset",
                     "public_policy_dataset")
