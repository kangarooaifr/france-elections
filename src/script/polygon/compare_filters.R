

#' Compare filter lists
#'
#' @param new a list
#' @param old a list
#'
#' @return a logical, whether the lists are same (TRUE) or not (FALSE)
#' @export
#'
#' @examples

compare_filters <- function(new, old){
  
  # init
  is_same <- TRUE
  
  # get difference between lists
  diff <- setdiff(new, old)
  
  # check
  if(length(diff) != 0)
    is_same <- FALSE
  
  # return
  is_same
  
}