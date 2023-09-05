
rm(list = ls())

library(tidyverse)
library(httr)
library(jsonlite)

# Documentation -----------------------------------------------------------

# Doc: https://unstats.un.org/sdgapi/swagger/#!/Indicator/V1SdgIndicatorListGet

apikey <- "ijibewtybkxwp79a8ps2zie2ec5zxunn"

# Get indicator ids
indicators_urlEndpoint <- "https://unstats.un.org/sdgapi/v1/sdg/Indicator/List"

r1 <- VERB("GET", indicators_urlEndpoint, 
          query = NULL,
          accept("application/json"))

rawContent_indicators <- content(r1, "text", encoding = "UTF-8")
json_listData <- fromJSON(rawContent_indicators)
indicator_data <- do.call(bind_rows, json_listData$series) %>% tibble

# Buscador

busqueda <- "equality"
indicator_data[str_detect(indicator_data$description, busqueda),]
indicator_data[str_detect(indicator_data$description, busqueda),]$description %>% cbind


