

#' Load csv with unknown amout of columns
#'
#' @param target_file the url of the file to be loaded
#' @param nb_cols a numeric value, to force read.csv to return result with this amount of columns
#'
#' @return a data.frame of the loaded dataset
#' @export
#'
#' @examples load_with_ukn_cols("./data/my_data.csv", nb_cols = 250)

load_with_ukn_cols <- function(target_file, nb_cols = 500){
  
  
  cat("-- Loading file with unknown nb of colums \n")
  cat("File : ", target_file, "\n")
  cat("nb_cols = ", nb_cols, "\n")
  
  # read file with nb_cols cols
  dat <- read.csv(target_file, col.names = paste("V",1:nb_cols), skip = 1, header = F, fill = T, sep = ",", dec = ",")
  
  # drop empty cols
  dat <- dat[colSums(!is.na(dat)) > 0]
  cat("Ouput dim = ", dim(dat), "\n")
  
  # return
  dat
  
}

