#!/usr/bin/Rscript

# Function to provide global summary of time series data
# data: the input data frame containing time series information
# year_name: the name of the column representing years in the data frame (default is "year")
# country_name: the name of the column representing countries in the data frame (default is "country")
globalSummary <- function(data, year_name = "year", country_name = "country") {
  
  years <- data[[year_name]]
  countries <- data[[country_name]]
  
  min_year <- min(years)
  max_year <- max(years)
  sorted_vector <- sort(unique(years))
  
  years_count <- length(unique(years))
  countries_count <- length(unique(countries))
  
  # Check if the years are continuous or discontinuous
  if (length(sorted_vector) == (max_year - min_year + 1)) {
    cat("Continuous series:", min_year, "-", max_year, "\n")
  } else {
    cat("Discontinuous series:")
    start <- sorted_vector[1]
    end <- start
    
    for (i in 2:length(sorted_vector)) {
      if (sorted_vector[i] == end + 1) {
        end <- sorted_vector[i]
      } else {
        cat(" ", start, "-", end, ",")
        start <- sorted_vector[i]
        end <- start
      }
    }
    
    cat(" ", start, "-", max_year, "\n")
  }
  cat("\n", years_count, " points in time.")
  cat("\n", countries_count, " countries.")
}

## Message:
# Print a message indicating that the globalSummary function is available
print("globalSummary function available")


# na_count: a function to count na values:
na_count <- function(x, rounded = 2){return(round(sum(is.na(x))/length(x), 2))}

## Message:
# Print a message indicating that na_count function is available
print("na_count function available")

# Dataset names values
dataset_names <- c("dataset_names", "na_count", "globalSummary",
                     "alcohol_harm_dataset", "income_dataset", "consumption_dataset",
                     "inequalities_dataset", "population_characteristics_dataset", 
                     "environmental_characteristics_dataset", "risk_factors_dataset", 
                     "comorbidities_dataset", "infrastructure_dataset",
                     "public_policy_dataset")
