

prepare_by_candidates <- function(data, pattern){
  
  cat("-- Prepare dataset by candidate, pattern =", pattern, "\n")
  
  # check pattern
  if(pattern == "Legislatives")
    COL_CLASSES_CANDIDATES <- COL_CLASSES_CANDIDATES_LEGISLATIVES
  else if(pattern == "Europeennes")
    COL_CLASSES_CANDIDATES <- COL_CLASSES_CANDIDATES_EUROPEENNES
  else
    COL_CLASSES_CANDIDATES <- COL_CLASSES_CANDIDATES_PRESIDENTIELLE
  
  # get values
  nb_cols_before <- length(COL_CLASSES_BEFORE_CANDIDATES)
  nb_cols_cand <- length(COL_CLASSES_CANDIDATES)
  
  # compute max number of candidates
  nb_cand <- (dim(data)[2] - nb_cols_before) / nb_cols_cand
  cat("Nb candidates (max): ", nb_cand, "\n")
  
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
  data <- as.data.frame(data.table::rbindlist(res, use.names=FALSE))
  
  # clean rows with only NA values (because circo have different amount of candidates!)
  if(pattern == "Legislatives")
    data <- data[!is.na(data$V.22), ]
  
  # set col names
  colnames(data) <- c(names(COL_CLASSES_BEFORE_CANDIDATES), names(COL_CLASSES_CANDIDATES))
  
  # drop cols with % values
  data <- data[!names(data) %in% RAW_COLS_TO_DROP]
  
  cat("Processing done. \n")
  
  # return
  data
  
}


# ------------------------------------------------------------------------------
# New function
# ------------------------------------------------------------------------------

prepare_by_candidates2 <- function(data, pattern, cols_before, cols_candidate){
  
  cat("-- Prepare dataset by candidate, pattern =", pattern, "\n")
  
  # get values
  nb_cols_before <- length(cols_before)
  nb_cols_cand <- length(cols_candidate)
  
  # compute max number of candidates
  nb_cand <- (dim(data)[2] - nb_cols_before) / nb_cols_cand
  cat("Nb candidates (max): ", nb_cand, "\n")
  
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
  data <- as.data.frame(data.table::rbindlist(res, use.names=FALSE))
  
  # clean rows with only NA values (because circo have different amount of candidates!)
  if(pattern == "Legislatives")
    data <- data[!is.na(data$V.22), ]
  
  # set col names
  colnames(data) <- c(names(cols_before), names(cols_candidate))
  
  # drop cols with % values
  data <- data[!names(data) %in% RAW_COLS_TO_DROP]
  
  cat("Processing done. \n")
  
  # return
  data
  
}
