

# Create a continuous palette function

makePalette <- function(min = 0, max = 1){
  
  cat("Make color palette, min = ", min, "max = ", max, "\n")
  
  colorNumeric(
    palette = "YlOrBr",
    domain = c(min, max))
  
}


#binpal <- colorBin("BrBG", c(0, 1), 5, pretty = FALSE)


#BrBG
#PuBuGn