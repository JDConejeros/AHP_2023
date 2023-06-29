
library(tidyverse)
library(httr)
library(jsonlite)

apikey <- "ijibewtybkxwp79a8ps2zie2ec5zxunn"

# Get indicator ids
indicators_urlEndpoint <- "https://api.healthdata.org/sdg/v1/GetIndicator"

r1 <- VERB("GET", indicators_urlEndpoint, 
          query = NULL,
          add_headers("Authorization" = apikey), 
          accept("application/json"))


rawContent_indicators <- content(r1, "text", encoding = "UTF-8")
indicator_data <- fromJSON(rawContent_indicators)$results

# Take a look:
# View(indicator_data)


# Get indicator data
indicatorData_urlEndpoint <- "https://api.healthdata.org/sdg/v1/GetResultsByIndicator"

queryString <- list(indicator_id = 1810) # expample indicator id

r2 <- VERB("GET", indicatorData_urlEndpoint, 
          query = queryString,
          add_headers("Authorization" = apikey), 
          accept("application/json"))

rawContent_indicators <- content(r2, "text", encoding = "UTF-8")
indicatorResults_data <- fromJSON(rawContent_indicators)$results

indicatorResults_data



