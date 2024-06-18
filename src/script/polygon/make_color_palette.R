

#' Build color palette
#'
#' @param geojson a geojson object
#' @param mode_min a logical, color palette min will be O when FALSE, min vote when TRUE
#' @param mode_max a logical, color palette max will be 10O when FALSE, max vote when TRUE
#'
#' @return a color palette function
#' @export
#'
#' @examples

make_color_palette <- function(geojson, mode_min = FALSE, mode_max = FALSE){
  
  cat("Building color palette \n")
  
  # -- prepare
  range <- geojson@data$Voix / geojson@data$Exprimés * 100
  
  # -- set min value to compute color palette
  min <- 0
  if(mode_min)
    min <- min(range, na.rm = TRUE)
  
  # -- set max value to compute color palette
  max <- 100
  if(mode_max)
    max <- max(range, na.rm = TRUE)
  
  # -- Create a continuous palette function
  cat("-- min = ", min, "max = ", max, "\n")
  colorNumeric(
    palette = "YlOrBr",
    domain = c(min, max))
  
}
