
# -- to use when code commune has wrong format [dep][code] instead of [code]
# ex: 01001 instead of 1

code_commune <- function(x, n = 3){

  substr(x, nchar(x) - n + 1, nchar(x))
  
}
