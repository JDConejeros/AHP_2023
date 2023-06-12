
## Quizás no se anecesario tener este apartado

# Función
comprobar_serie <- function(serie) {
  
  condicion_verificada <- any(sort(unique(serie)) == (1:length(unique(serie)) + min(serie) - 1))
  
  if (length(unique(serie)) == length(min(serie):max(serie))) {
    return(paste0("Serie sin discontinuidades: ", min(serie), "-", max(serie)))
  } else {
    return("Hay discontinuidades") # Sería genial desarrollar un bucle for que vaya detectando las discontinuidades y arme el string de las secuencias...
  }
}

comprobar_serie(c(1:3,5:6))

serie <- c(1:100)

comprobar_serie(serie)

# Ok, puede que elimine esta función jaja, pero apaña para ver si la serie de años es continua.
