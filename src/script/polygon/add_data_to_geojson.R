

#' Merge data into geojson
#'
#' @param geojson a geojson object
#' @param data a data.frame (codgeo column is mandatory)
#'
#' @return a geojson with @data containing the input data.frame
#' @export
#'
#' @examples

add_data_to_geojson <- function(geojson, data){
  
  cat("Add data values to geojson, input dim =", dim(geojson), "\n")
  
  # -- get cols (exclude codgeo)
  cols <- colnames(data)
  cols <- cols[!cols %in% "codgeo"]
  
  # -- match
  geojson@data[cols] <- data[match(geojson@data$codgeo, data$codgeo), cols]
  cat("-- output dim =", dim(geojson@data), "\n")
  
  # -- Debug
  if(DEBUG)
    DEBUG_GEOJSON_WITH_DATA <<- geojson
  
  # -- return
  geojson
  
}
