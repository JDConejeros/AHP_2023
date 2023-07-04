
# General
general_missings <- ahp_data %>% 
  sapply(function(x){sum(is.na(x)/length(x))}) %>% 
  as.data.frame

general_missings$variable  <-  rownames(general_missings)
general_missings <- general_missings[, c(ncol(general_missings), 1)]

OUT <- createWorkbook()

addWorksheet(OUT, "General")
writeData(OUT, sheet = "General", x = general_missings)
saveWorkbook(OUT, "dataset_generation/missing_analysis/Missings_General.xlsx", overwrite = TRUE)


# By year
list_yearMissings <- list()

for(i in 1:length(unique(ahp_data$year))){
  list_yearMissings[[i]] <- ahp_data %>% 
    filter(year == sort(unique(ahp_data$year))[i]) %>% 
    sapply(function(x){sum(is.na(x)*100/length(x))}) %>% 
    as.data.frame %>% 
    setNames(as.character(sort(unique(ahp_data$year))[i]))
}

year_missings <- do.call(cbind, list_yearMissings) %>% slice(3:ncol(ahp_data))
# 
# year_missings$variable  <-  rownames(year_missings)
# year_missings <- year_missings[, c(ncol(year_missings), 1:(ncol(year_missings)-1))]

OUT <- createWorkbook()

addWorksheet(OUT, "By Year")
writeData(OUT, sheet = "By Year", x = year_missings, colNames = TRUE, rowNames = TRUE)
saveWorkbook(OUT, "dataset_generation/missing_analysis/Missings_By_Year.xlsx", overwrite = TRUE)


# By country
list_countryMissings <- list()

for(i in 1:length(unique(ahp_data$country))){
  list_countryMissings[[i]] <- ahp_data %>% 
    filter(country == unique(ahp_data$country)[i]) %>% 
    sapply(function(x){sum(is.na(x)*100/length(x))}) %>% 
    as.data.frame %>% 
    setNames(unique(ahp_data$country)[i])
}

country_missings <- do.call(cbind, list_countryMissings) %>% data.frame

country_missings$variable <- rownames(country_missings)
country_missings <- country_missings[, c(ncol(country_missings), 1:(ncol(country_missings)-1))]

OUT <- createWorkbook()
addWorksheet(OUT, "By Country")
writeData(OUT, sheet = "By Country", x = country_missings, colNames = TRUE, rowNames = TRUE)

# Create Excel file
saveWorkbook(OUT, "dataset_generation/missing_analysis/Missings_By_Country.xlsx", overwrite = TRUE)

# D1-Alcohol harm dataset -------------------------------------------------


startVariableIndex_dim1 <- 3
endVariableIndex_dim1 <- 29

lista <- list()
variableNames <- names(ahp_data)[startVariableIndex_dim1:endVariableIndex_dim1]

for (i in startVariableIndex_dim1:endVariableIndex_dim1) {
  lista[[i - 2]] <- ahp_data[, c("country", "year", names(ahp_data)[i])] %>%
    group_by(country, year) %>%
    summarise_all(function(x) { sum(is.na(x), na.rm = TRUE) }) %>%
    pivot_wider(names_from = year, values_from = names(ahp_data)[i])
}

names(lista) <- variableNames

OUT <- createWorkbook()

for (i in variableNames) {
  addWorksheet(OUT, i)
  writeData(OUT, sheet = i, x = lista[[i]], startRow = 2, colNames = TRUE)
  writeData(OUT, sheet = i, x = c("Country", "Year", names(ahp_data)[i]), startRow = 0, colNames = FALSE)
}

saveWorkbook(OUT, "dataset_generation/missing_analysis/missings_DIM1_alcohol_harm.xlsx", overwrite = TRUE)



# DIM 2 Income ------------------------------------------------------------
startVariableIndex_dim2 <- 30
endVariableIndex_dim2 <- 35

lista <- list()
variableNames <- names(ahp_data)[startVariableIndex_dim2:endVariableIndex_dim2]

for (i in startVariableIndex_dim2:endVariableIndex_dim2) {
  lista[[i - 2]] <- ahp_data[, c("country", "year", names(ahp_data)[i])] %>%
    group_by(country, year) %>%
    summarise_all(function(x) { sum(is.na(x), na.rm = TRUE) }) %>%
    pivot_wider(names_from = year, values_from = names(ahp_data)[i])
}

names(lista) <- variableNames

OUT <- createWorkbook()

for (i in variableNames) {
  addWorksheet(OUT, i)
  writeData(OUT, sheet = i, x = lista[[i]], startRow = 2, colNames = TRUE)
  writeData(OUT, sheet = i, x = c("Country", "Year", names(ahp_data)[i]), startRow = 0, colNames = FALSE)
}

saveWorkbook(OUT, "dataset_generation/missing_analysis/missings_DIM2_income.xlsx", overwrite = TRUE)


# DIM3 Consumption --------------------------------------------------------

startVariableIndex_dim2 <- 36
endVariableIndex_dim2 <- 76

lista <- list()
variableNames <- names(ahp_data)[startVariableIndex_dim2:endVariableIndex_dim2]

for (i in startVariableIndex_dim2:endVariableIndex_dim2) {
  lista[[i - 2]] <- ahp_data[, c("country", "year", names(ahp_data)[i])] %>%
    group_by(country, year) %>%
    summarise_all(function(x) { sum(is.na(x), na.rm = TRUE) }) %>%
    pivot_wider(names_from = year, values_from = names(ahp_data)[i])
}

names(lista) <- variableNames

OUT <- createWorkbook()

for (i in variableNames) {
  addWorksheet(OUT, i)
  writeData(OUT, sheet = i, x = lista[[i]], startRow = 2, colNames = TRUE)
  writeData(OUT, sheet = i, x = c("Country", "Year", names(ahp_data)[i]), startRow = 0, colNames = FALSE)
}

saveWorkbook(OUT, "dataset_generation/missing_analysis/missings_DIM3_consumption_dataset.xlsx", overwrite = TRUE)


