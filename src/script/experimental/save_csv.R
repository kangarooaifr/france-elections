


#' Save data to csv
#'
#' @param path the target path
#' @param file the name of the file
#' @param data the data
#'
#' @return
#' @export
#'
#' @examples

save_csv <- function(path = path$data_prepared, file = file, data = dataset){
  
  # write file
  write.csv2(data, 
            file = file.path(path, file),
            quote = FALSE,
            row.names = FALSE,
            fileEncoding = "")
  
  cat("File ", file, "saved. \n")
  
}
