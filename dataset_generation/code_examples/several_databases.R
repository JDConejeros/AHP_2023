
# List of csv files in data folder
my_files <- list.files("dataset_generation/files/data/wid_all_data/") %>% 
  grep("WID_data_[A-Z0-9-]", ., value = TRUE) %>%
  paste0("dataset_generation/files/data/wid_all_data/",.)

# Creating an empty list
dataframes <- list()

# Mapply
mapply(function(i,j) {
  if(nrow(fread(i)) > 0) dataframes[[j]] <<- fread(i)
  }, my_index, 1:length(my_index))
income_inequality <- do.call(bind_rows, dataframes)


# Metadata analysis -------------------------------------------------------

dir("dataset_generation/files/data/wid_all_data/")

lista <- list.files("dataset_generation/files/data/wid_all_data/") %>% 
  grep("WID_metadata_[A-Z0-9-]", ., value = TRUE) %>%
  sample(size = 5) %>% 
  paste0("dataset_generation/files/data/wid_all_data/",.)

metadata_1 <- fread(lista[1])
metadata_2 <- fread(lista[2])
metadata_3 <- fread(lista[3])

datas <- list(metadata_1, metadata_2, metadata_3)

datas %>% lapply(dim)

metadata_1[str_detect(metadata_1$simpledes, "ineq"),]$shortname

metadata_1 %>% names %>% cbind

metadata_1 %>% select(shortname, simpledes)



index <- length(metadata_1$simpledes)

my_metadata_files <- list.files("dataset_generation/files/data/wid_all_data/") %>% 
  grep("WID_metadata_[A-Z0-9-]", ., value = TRUE) %>%
  paste0("dataset_generation/files/data/wid_all_data/",.)

my_metadata_files[str_detect(my_metadata_files, "CL")]










