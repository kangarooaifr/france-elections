

#' Add codgeo to data.frame
#'
#' @param data a data.frame
#' @param commune a boolean, wether codgeo will be added (default = TRUE)
#' @param circonscription a boolean, wether codgeo will be added (default = TRUE)
#'
#' @return a data.frame with added columns
#' @export
#'
#' @examples

add_codgeo <- function(data, commune = TRUE, circonscription = TRUE){
  
  cat("-- Adding codgeo columns \n")
  
  # -- build codgeo from dep + commune
  if(commune)
    data$codgeo.commune <- paste0(data[[1]], stringr::str_pad(data[[3]], 3, pad = "0")) 
  
  # -- build codgeo from dep + circonscription
  if(circonscription)
    data$codgeo.circonscription <- paste0(data[[1]], stringr::str_pad(data[[3]], 3, pad = "0"))
  
  # return
  data
  
}

