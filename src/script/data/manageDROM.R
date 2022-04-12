

check_drom_code <- function(data){
  
  
  cat("Checking DROM code")
  
  
  # ---------------------------------------------------------
  # DROM : Departement et Region d'Outre-Mer
  # ---------------------------------------------------------
  
  # values
  old_drom <- c("ZA", "ZB", "ZC", "ZD", "ZM", "ZS", "ZX")
  
  # to become
  #new_drom <- c("971", "972", "973", "974", "976")
  new_drom <- "97"
  
  # "Guadeloupe" 971
  # "Martinique" 972
  # "Guyane" 973
  # "La Réunion" 974
  # "Mayotte" 976
  
  data$Code.du.département[data$Code.du.département %in% old_drom] <- new_drom
  
  # ---------------------------------------------------------
  # TOM / COM : Territoires et Collectivités d'Outre-Mer
  # ---------------------------------------------------------
  
  # values
  old_tom_com <- c("ZN", "ZP", "ZW")
  
  
  # to become
  #new_tom_com <- c("988", "987", "986")
  new_tom_com <- "98"
  
  # "Nouvelle-Calédonie" 988 ?
  # "Polynésie française" 987 ?
  # "Saint-Pierre-et-Miquelon" 975  ? 
  # "Wallis et Futuna" 986 ?
  # "Saint-Martin/Saint-Barthélemy" 977 ?
  
  data$Code.du.département[data$Code.du.département %in% old_tom_com] <- new_tom_com
  
  # return
  data
  
}
