
# PLEACE NOTE: The rnoaa package will soon be retired and archived because the 
# underlying APIs have changed dramatically. The package currently works but
# does not pull the most recent data in all cases. A noaaWeather package is 
# planned as a replacement but the functions will not be interchangeable.

# Token: ------------------------------------------------------------------

mi_token <- "MOwhbHiSbLpvvbxtOKJTxMHFfTUBfsDH"



# httr --------------------------------------------------------------------

## Ver los datasets disponibles --------------------------------------------

library(httr)
library(jsonlite)

endpoint <- "https://www.ncei.noaa.gov/cdo-web/api/v2/datasets"

response_1 <- VERB("GET", endpoint,
                query = NULL,
                add_headers("token" = mi_token), 
                accept("application/json"))

aviable_datasets_content <- content(response_1, "text")


aviable_datasets <- fromJSON(aviable_datasets_content)$results


## Extraer dataset ---------------------------------------------------------

endpoint <- "https://www.ncei.noaa.gov/cdo-web/api/v2/data"

response_2 <- VERB("GET", endpoint,
                query = list(datasetid = "GSOY", 
                             startdate = "2010-01-01", 
                             enddate = "2011-01-01", 
                             limit = 1000),
                add_headers("token" = mi_token),
                accept("application/json"))

global_temperature_content <- content(response_2, "text")

global_temperature <- fromJSON(global_temperature_content)$results



# Locations ---------------------------------------------------------------

# Observar las localidades
endpoint <- "https://www.ncei.noaa.gov/cdo-web/api/v2/locations"


response_3 <- VERB("GET", endpoint,
                query = list(limit = 1000,
                             locationcategoryid = "CITY"),
                add_headers("token" = mi_token), 
                accept("application/json"))


locations_content <- content(response_3, "text")


locations <- fromJSON(locations_content)$results


# Una localidad en particular:

endpoint <- "https://www.ncei.noaa.gov/cdo-web/api/v2/locations/FIPS:37"

# Ver una regularidad en las fechas ¿cada cuanto se mide el clima?

i <- "2010-01-01"
j <- "2010-01-02"

response_4 <- VERB("GET", endpoint,
                query = list(startdate = i, 
                             enddate = j, 
                             limit = 1000),
                add_headers("token" = mi_token), 
                accept("application/json"))

aviable_datasets_content <- content(response_4, "text")


aviable_datasets <- fromJSON(aviable_datasets_content)$results

View(aviable_datasets)




# Paquete rnoaa -----------------------------------------------------------

library(tidyverse)
library(rnoaa)

# Repository: https://github.com/ropensci/rnoaa

# # Request your token at: https://www.ncdc.noaa.gov/cdo-web/token
options(noaakey = "MOwhbHiSbLpvvbxtOKJTxMHFfTUBfsDH")

# Request data
out <- ncdc(datasetid = 'GSOY', 
            # locationid = 'ZIP:28801', 
            datatypeid = 'HPCP', 
            startdate = '2013-10-01', 
            enddate = '2013-12-01', 
            limit = 1000) # limit: 1000

head(out)