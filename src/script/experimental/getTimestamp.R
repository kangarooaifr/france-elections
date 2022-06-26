


#' Computes timestamp
#'
#' @return A numeric value
#'
#' @examples getTimestamp()


getTimestamp <- function()
{
  
  # init timestamp
  timestamp <- round(as.numeric(Sys.time())*1000, digits = 0)
  
  # trace
  cat("timestamp = ", as.character(timestamp), "\n")
  
  # return
  timestamp
  
}

