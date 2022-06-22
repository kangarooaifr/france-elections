

library(dplyr)


pre_processing <- function(data, nb_cand, nb_col_before, nb_col_candidate){
  
  cat("Performing data preprocessing with: \n")
  cat("- nb_cand = ", nb_cand, "\n")
  cat("- nb_col_before = ", nb_col_before, "\n")
  cat("- nb_col_candidate = ", nb_col_candidate, "\n")
  
  # helper
  helper_function <- function(candidate){
    
    cat("Merging candidate =", candidate, "\n")
    
    # computing first column of candidate
    col_start <- (nb_col_before + 1) + nb_col_candidate * (candidate - 1)
    
    # get candidate name
    name <- paste(unique(data[col_start + 2]), unique(data[col_start + 3]))
    
    # get candidate votes
    output <- data[col_start + 4]
    colnames(output) <- name
    
    # return
    output
    
  }
  
  # apply helper
  list_df <- lapply(1:nb_cand, helper_function)
  
  # bind rows
  cat("Binding all columns \n")
  data <- data[1:nb_col_before]
  
  data_out <- bind_cols(data, list_df)
  
}