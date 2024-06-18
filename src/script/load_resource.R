

load_resource <- function(path, file, header = TRUE, format = NULL, encoding = "unknown"){
  
  cat("Load resource file :", file, "\n")
  
  # -- build url
  target_file <- file.path(path, file)
  
  # -- read file
  data <- read.csv(target_file, header = header, encoding = encoding)
  
  # -- init
  output <- data
  
  # -- check format
  if(format == "vector"){
    
    # -- create vector with values from last col
    output <- data[[dim(data)[2]]]
    
  }
  
  # -- check format
  if(format == "named_vector"){
    
    # -- create vector with values from second col
    output <- data[[2]]
    
    # -- set names with first col
    names(output) <- data[[1]]
    
  }
  
  # -- return
  output
  
}