

#' List available datasets
#'
#' @param pattern the pattern to be passed to list.files
#'
#' @return a data.frame of the available datasets
#' @export
#'
#' @examples

get_available_datasets <- function(pattern){
  
  # get list of dataset
  data_list <- list.files(path$data_prepared, pattern = pattern, full.names = FALSE, recursive = FALSE, include.dirs = FALSE)
  cat("Available datasets :", length(data_list), "\n")
  
  # build data frame (remove ext, split file name into cols)
  data_list <- data.frame(file.name = data_list)
  data_list[c('election', 'annee', 'tour')] <- str_split_fixed(sub('\\.txt$', '', data_list$file.name), '_', 3)
  
  # return
  data_list
  
}
