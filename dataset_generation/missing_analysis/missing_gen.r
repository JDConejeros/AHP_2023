



# D1-Alcohol harm dataset -------------------------------------------------
lista = list()

for(i in 3:4){ # ncol(ahp_data)
  lista[[i-2]] <- ahp_data[,c("country", "year", names(ahp_data)[i])] %>% 
  group_by(country, year) %>% 
  summarise_all(function(x){sum(is.na(x))}) %>% 
  pivot_wider(names_from = year, values_from = names(ahp_data)[i], 
              names_prefix=names(ahp_data)[i])
}

names(lista) <- names(ahp_data)[3:4]



etiquietas = names(ahp_data)[3:4]

OUT <- createWorkbook()

for(i in names(ahp_data)[3:4]){
  addWorksheet(OUT, i)
  writeData(OUT, sheet = i, x = lista[i])
}

saveWorkbook(OUT, "dataset_generation/missings_DIM1_alcohol_harm.xlsx")










