

#' Check new dataset
#'
#' @param pattern a string to be used as pattern for list.files
#'
#' @return a character vector with the names of the new files (the ones without clones in prepared folder)
#' @export
#'
#' @examples check_new_files(pattern = "Legislatives_")


check_new_files <- function(pattern){
  
  # -- get list of datasets
  raw_files <- list.files(path$data_raw, pattern = pattern, full.names = FALSE, recursive = FALSE, include.dirs = FALSE)
  
  # -- get list of prepared datasets
  prepared_files <- list.files(path$data_prepared, pattern = pattern, full.names = FALSE, recursive = FALSE, include.dirs = FALSE)
  
  # -- list new datasets
  new_files <- raw_files[!raw_files %in% prepared_files]
  
  if(length(new_files) == 0)
    new_files <- NULL
  else
    cat("New dataset(s) found :", length(new_files), "\n")
  
  # -- return
  new_files

}
