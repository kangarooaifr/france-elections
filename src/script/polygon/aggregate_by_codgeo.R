
library(dplyr)



aggregate_by_codgeo <- function(geo_type, data, election_type){
  
  cat("Aggregate data by codgeo \n")
  
  # check geo_type
  if(geo_type == "Circonscriptions législatives 2012"){
   
    cat("-- codgeo.circonscription \n")
    
    # check election_type
    if(election_type == "leg")
      cols_unique <- COLS_UNIQUE_CIRCO_LEG
    else if(election_type == "eur")
      cols_unique <- COLS_UNIQUE_CIRCO_EUR
    else
      cols_unique <- COLS_UNIQUE_CIRCO_PDT
    
    # aggregate (sum)
    res_sum <- aggregate(data[COLS_TO_SUM], by = list("codgeo.circonscription" = data$codgeo.circonscription), FUN = sum)
    
    # aggregate (unique val)
    res_unique <- aggregate(data[cols_unique], by = list("codgeo.circonscription" = data$codgeo.circonscription), FUN = unique)
    res_unique$codgeo.circonscription <- NULL
  
    # bind results
    output <- cbind(res_unique, res_sum)
    
  } else {
    
    cat("-- codgeo.commune \n")
    
    # check election_type
    if(election_type == "leg")
      cols_unique <- COLS_UNIQUE_COMMUNE_LEG
    else if(election_type == "eur")
      cols_unique <- COLS_UNIQUE_COMMUNE_EUR
    else
      cols_unique <- COLS_UNIQUE_COMMUNE_PDT
    
    # aggregate
    res_sum <- aggregate(data[COLS_TO_SUM], by = list("codgeo.commune" = data$codgeo.commune), FUN = sum)
    
    # aggregate (unique val)
    res_unique <- aggregate(data[cols_unique], by = list("codgeo.commune" = data$codgeo.commune), FUN = unique)
    res_unique$codgeo.commune <- NULL
    
    # bind results
    output <- cbind(res_unique, res_sum)
    
  }
  
  # debug
  if(DEBUG)
    DEBUT_AGGREGATE_CODGEO <<- output
  
  cat("-- output dim =", dim(output), "\n")
  
  # return
  output
  
}
