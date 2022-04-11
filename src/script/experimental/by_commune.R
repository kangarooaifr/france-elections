
by_commune <- function(){

  
  PR17_T2 <- read.csv("./data/PR17_BVot_T2_FE.txt", header = TRUE, sep = ";")
  
  input_commune <- "Charenton-le-Pont"
  
  data_Map[data_Map@data$libgeo == input_commune, ]
  
  codgeo <- data_Map[data_Map@data$libgeo == input_commune, ]$codgeo
  
  code_departement <- substr(codgeo, 1, 3)
  if (substr(code_departement, 3,3) == "0"){
    code_departement <- substr(code_departement, 1, 2)
  }
  
  code_commune <- substr(codgeo, 4, 5)
  
  PR17_T2[PR17_T2$Code.du.département == code_departement & PR17_T2$Code.de.la.commune == code_commune, ]
  
  PR17_T2_Merge[PR17_T2_Merge$Code.du.département == code_departement & PR17_T2_Merge$Code.de.la.commune == code_commune, ]
  
}