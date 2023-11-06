
# Packages

if(!require("pacman")){
  install.packages("pacman")
}

pacman::p_load(janitor, 
               countrycode, 
               foreign,
               tidyverse,
               haven,
               openxlsx,
               data.table,
               httr,
               jsonlite,
               WDI,
               owidR, 
               ghost,
               rnoaa)

