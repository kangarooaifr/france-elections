
mygeocode <- function(addresses)
{
  # addresses: vector with all addresses as character
  
  nominatim_osm <- function(address = NULL)
  {

    if(suppressWarnings(is.null(address)))
      return(data.frame())
    
    request <- paste0("https://nominatim.openstreetmap.org/search?q=", address, "+france", "&format=jsonv2&limit=1")
    cat("Request =", request, "\n")
    
    tryCatch(
      d <- jsonlite::fromJSON(request), 
      error = function(c) return(data.frame()))
    
    if(length(d) == 0)
      return(data.frame())
    
    cat("Output =", d$display_name, "\n")
    
    return(c(as.numeric(d$lon), as.numeric(d$lat)))
  }
  
  # apply helper function
  tableau <- t(sapply(addresses, nominatim_osm))
  
  # colnames when some result is found
  if(dim(tableau)[2] > 1)
  {
    colnames(tableau) <- c("lng","lat")
  }
  else{
    tableau <- NULL
  }
  
  # return
  tableau
  
}