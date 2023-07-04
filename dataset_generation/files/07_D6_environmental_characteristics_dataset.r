
# 42-temperature ----------------------------------------------------------
temperature
population <- WDI(indicator = "NY.GDP.MKTP.CD")

population <- population[,c(1,4,5)] %>% setNames(c("country", "year", "population"))


# 43-precipitation --------------------------------------------------------
precepitation
population <- WDI(indicator = "NY.GDP.MKTP.CD")

population <- population[,c(1,4,5)] %>% setNames(c("country", "year", "population"))
