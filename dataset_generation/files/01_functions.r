
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

