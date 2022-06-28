

#' Subset geojson data by codgeo
#'
#' @param geo_type a string ("Communes", "Circonscriptions législatives 2012")
#' @param geojson a geojson data object
#' @param codgeo a vector of the codgeo
#'
#' @return a subset of the geojson
#' @export
#'
#' @examples

subset_geojson <- function(geo_type, geojson, data){
  
  # log
  cat("Subset geojson with matching codgeo \n")
  
  # check geojson type
  if(geo_type == "Circonscriptions législatives 2012"){

    # subset
    geojson <- geojson[geojson@data$codgeo %in% data$codgeo.circonscription, ]
    
    # debug
    if(DEBUG)
      DEBUG_SUBSET_GEOJSON <<- geojson}
 
  
  cat("-- output dim =", dim(geojson@data), "\n")
  
  # return
  geojson
  
}
