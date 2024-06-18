

code_commune <- function(x, n = 3){

  substr(x, nchar(x) - n + 1, nchar(x))
  
}
