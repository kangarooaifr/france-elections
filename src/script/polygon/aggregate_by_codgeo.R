
library(dplyr)



aggregate_by_codgeo <- function(geo_type, data){
  
  cat("Aggregate data by codgeo \n")
  
  # check geo_type
  if(geo_type == "Circonscriptions législatives 2012"){
   
    # define columns to sum
    cols_to_sum <- c("Inscrits", 
                     "Abstentions", 
                     "Votants", 
                     "Blancs", 
                     "Nuls", 
                     "Exprimés", 
                     "Voix")
    # aggregate
    res_sum <- aggregate(data[cols_to_sum], by = list("codgeo.circonscription" = data$codgeo.circonscription), FUN = sum)
    
    # define columns to unique
    cols_unique <- c("Code.du.département", 
                     "Libellé.du.département", 
                     "Code.de.la.circonscription", 
                     "Libellé.de.la.circonscription",
                     "N.Panneau",
                     "Sexe",
                     "Nom",
                     "Prénom",
                     "Nuance")
    
    # aggregate
    res_unique <- aggregate(data[cols_unique], by = list("codgeo.circonscription" = data$codgeo.circonscription), FUN = unique)
    res_unique$codgeo.circonscription <- NULL
  
    # bind results
    output <- cbind(res_unique, res_sum)
    
  }
  
  # codgeo.commune
  
  cat("-- output dim =", dim(output), "\n")
  
  # return
  output
  
}
