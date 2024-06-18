


#' Computes timestamp
#'
#' @return A numeric value
#'
#' @examples getTimestamp()


getTimestamp <- function(verbose = FALSE)
{
  
  # -- init timestamp
  timestamp <- round(as.numeric(Sys.time())*1000, digits = 0)
  
  # -- trace
  if(verbose)
    cat("timestamp = ", as.character(timestamp), "\n")
  
  # -- return
  timestamp
  
}

