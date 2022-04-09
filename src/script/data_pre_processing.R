

library(data.table)

# data preprocessing
# merge candidate cols (col to row)

pre_process_data <- function(data, nb_cand){
  
  cat("Performing data preprocessing with nb_cand = ", nb_cand, "\n")
  
  # helper
  helper_function <- function(candidate){
    
    col_start <- 22 + 7 * (candidate -1)
    col_end <- col_start + 6
    
    data[c(1:21,col_start:col_end)]
    
  }
  
  # apply helper
  list_df <- lapply(1:nb_cand, helper_function)
  # bind rows
  data_out <- rbindlist(list_df, use.names = FALSE)
  
}