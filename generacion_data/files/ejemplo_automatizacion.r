
##* Este script es un ejemplo de automatización del proceso
##* de extracción de data de la API de WorldBank.


# List of indicator names and corresponding labels
indicators <- c("gdp", "gdp_per_capita", "cpi", "deflator")
labels <- c("Nominal GDP (current US$)", 
            "Nominal GDP per capita (current US$)",
            "Inflation, consumer prices (annual %)",
            "Inflation, GDP deflator (annual %)")

# List of datasets
{
  start <- Sys.time()
  datasets_list <- list(
    gdp = WDI(indicator = "NY.GDP.MKTP.CD"),
    gdp_per_capita = WDI(indicator = "NY.GDP.MKTP.CD"),
    cpi = WDI(indicator = "FP.CPI.TOTL.ZG"),
    deflator = WDI(indicator = "NY.GDP.DEFL.KD.ZG")
    )
  end <- Sys.time() - start ; end
}

# Create a list to store the cleaned datasets
datasets <- lapply(indicators, function(indicator) {
  data <- datasets_list[[indicator]][, c(1, 4, 5)] %>% setNames(c("country", "year", indicator))
  
  data <- data %>% 
    mutate(iso3c = countrycode(country, origin = 'country.name', destination = 'iso3c')) %>% 
    relocate(1,4,2,3) %>% 
    as_tibble() %>% 
    filter(!is.na(iso3c))
  
  data <- data %>% 
    mutate(!!sym(indicator) := as.numeric(!!sym(indicator)),
           !!sym(indicator) := labelled(!!sym(indicator), label = labels[indicator])) %>% 
    select(-country)
  
  data
})

# Verify the result
result <- datasets %>% 
  reduce(inner_join, by = c("iso3c", "year"))

result
