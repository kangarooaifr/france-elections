

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

leg_apply_filters <- function(x, filter, module){
  
  # subset by dep
  if(filter$dep != "tous"){
    
    cat(module, "Filter by dep, input =", filter$dep, "\n")
    x <- x[x$Code.du.département %in% filter$dep, ]
    cat(module, "-- output dim =", dim(x), "\n")}
  
  # subset by nuance
  cat(module, "Filter by nuance, input =", filter$name, "\n")
  x <- x[x$Nuance %in% filter$name, ]
  cat(module, "-- output dim =", dim(x), "\n")
  
  # return
  x
  
}
