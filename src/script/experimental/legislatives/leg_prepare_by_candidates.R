

library(data.table)


leg_prepare_by_candidates <- function(data){
  
  cat("-- Prepare dataset by candidate: START \n")
  
  # get values
  nb_cols_before <- length(COL_CLASSES_BEFORE_CANDIDATES)
  nb_cols_cand <- length(COL_CLASSES_CANDIDATES_LEGISLATIVES)
  
  # compute max number of candidates
  nb_cand <- (dim(data)[2] - nb_cols_before) / nb_cols_cand
  cat("Max candidates: ", nb_cand, "\n")
  
  # helper function
  helper <- function(x){
    
    # compute cols index
    start <- nb_cols_before + 1 + (x - 1) * nb_cols_cand
    end <- nb_cols_before + x * nb_cols_cand
    
    cols_to_keep <- c(1:nb_cols_before, c(start:end))
    
    # subset
    data[cols_to_keep]
    
  }
  
  # apply helper and bind result
  res <- lapply(1:nb_cand, function(x) helper(x))
  data <- as.data.frame(rbindlist(res, use.names=FALSE))
  
  # clean rows with only NA values (when circo has less candidates than max)
  data <- data[!is.na(data$V.22), ]
  
  # set col names
  colnames(data) <- c(names(COL_CLASSES_BEFORE_CANDIDATES), names(COL_CLASSES_CANDIDATES_LEGISLATIVES))
  
  # drop cols with %
  data <- data[!names(data) %in% LEG_COLS_TO_DROP]
  
  cat("Dataset processing done. \n")
  
  # return
  data
  
}