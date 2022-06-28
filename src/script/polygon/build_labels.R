

#' Build polygon labels
#'
#' @param geojson a geojson object
#' @param name a string to display within the label result line (who)
#'
#' @return a list of labels
#' @export
#'
#' @examples

build_labels <- function(geojson){
  
  cat("Building labels \n")
  
  # prepare labels
  labels <- sprintf(
    
    # pattern
    "<strong>%s</strong><br/><br/>%s<br/><br/>%s<br/>%s<br/>%s<br/>%s<br/>%s<br/>%s",
    
    # libgeo
    geojson@data$libgeo, 
    
    # result for selected candidate / nuance
    paste(geojson@data$Prénom, geojson@data$Nom, paste0("(", geojson@data$Nuance, ") :"),
          geojson@data$Voix, "voix,",
          round(geojson@data$Voix / geojson@data$Exprimés * 100, digits = 2), "%"),
    
    # additional info
    paste("Inscrits :", geojson@data$Inscrits),
    paste("Abstentions :", geojson@data$Abstentions, paste0("(", round(geojson@data$Abstentions / geojson@data$Inscrits * 100, digits = 2), "%)")),
    paste("Votants :", geojson@data$Votants),
    paste("Blancs :", geojson@data$Blancs),
    paste("Nuls :", geojson@data$Nuls),
    paste("Exprimés :", geojson@data$Exprimés)
  ) %>% lapply(htmltools::HTML)
  
  # debug
  if(DEBUG)
    DEBUG_LABELS <<- labels
  
  cat("-- output dim =", length(labels),"\n")
  
  # return
  labels
  
}