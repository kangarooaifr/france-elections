

#' Apply filters
#'
#' @param x the data (a data.frame)
#' @param filter the list of filters to be applied
#' @param module the name of the calling module (for log)
#'
#' @return the filtered data.frame
#' @export
#'
#' @examples

pdt_apply_filters <- function(x, filter, module){
  
  # subset by dep
  if(filter$dep != "tous"){
    
    cat(module, "Filter by dep, input =", filter$dep, "\n")
    x <- x[x$Code.du.département %in% filter$dep, ]
    cat(module, "-- output dim =", dim(x), "\n")}
  
  # subset by nuance
  cat(module, "Filter by name, input =", filter$name, "\n")
  # add tmp col because of merged Nom + Prénom in input!
  x$tmp_name <- paste(x$Nom, x$Prénom)
  # subset
  x <- x[x$tmp_name %in% filter$name, ]
  # drop tmp col
  x$tmp_name <- NULL
  cat(module, "-- output dim =", dim(x), "\n")
  
  if(DEBUG)
    DEBUG_PDT_APPLY_FILTER <<- x
  
  # return
  x
  
}
