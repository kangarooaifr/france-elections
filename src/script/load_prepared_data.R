

load_prepared_data <- function(target_file, colClasses, session){
  
  cat(">> Load prepared dataset \n")
  
  # build target file
  target_file <- file.path(path$data_prepared, target_file)
  cat("Target_file :", target_file, "\n")
  
  # monitoring
  start <- getTimestamp()
  
  # read file
  #dataset <- read.csv(target_file, header = TRUE, sep = ";", dec = ",", colClasses = colClasses, fileEncoding = "latin1")
  withProgress(message = 'Chargement...', value = 0.25, {
    dataset <- read.csv(target_file, header = TRUE, sep = ";", dec = ",", colClasses = colClasses, fileEncoding = "UTF-8", encoding = "Latin1")})
  
  # monitoring
  end <- getTimestamp()
  
  # notify user
  showNotification(ui = paste("Résultats chargés. (", (end - start) / 1000, "s)"),
                   duration = 5,
                   closeButton = TRUE,
                   type = c("default"),
                   session = session)
  
  # debug
  if(DEBUG)
    DEBUG_PREPARED_DATASET <<- dataset
  
  # return
  dataset
  
}