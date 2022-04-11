

library(dplyr)

# feat_engineering <- function(data){
#   
#   cat("Computing feaure engineering... \n")
#   
#   ouput <- data %>%
#     
#     # group by
#     group_by(N.Panneau, Libellé.de.la.commune) %>%
#     
#     # summarise
#     summarise(nb.b.vote = n(),
#               Inscrits = sum(Inscrits),
#               Abstentions = sum(Abstentions),
#               Votants = sum(Votants),
#               Blancs = sum(Blancs),
#               Nuls = sum(Nuls),
#               Exprimés = sum(Exprimés),
#               N.Panneau = unique(N.Panneau),
#               Nom = unique(Nom),
#               Prénom = unique(Prénom),
#               Voix = sum(Voix),
#               X.Voix.Exp = sum(Voix) / sum(Exprimés))
#   
# }
# 
# 
# feat_engineering2 <- function(data, cols_to_keep, candidates){
#   
#   cat("Computing feaure engineering... \n")
#   
#   ouput <- data %>%
#     
#     # group by
#     group_by(Libellé.de.la.commune) %>%
#     
#     # summarise
#     summarise_at(c(cols_to_keep, candidates), sum, na.rm = TRUE)
#   
# }


feat_engineering <- function(data, cols_to_keep, candidates){
  
  cat("Computing feature engineering... \n")
  cat("- Input data =", dim(data), "\n")
  cat("- Cols to sum :", cols_to_keep, "\n")
  cat("- Candidates :", candidates, "\n")
  
  # build codgeo from dep + commune
  cat("Build geocod column \n")
  data$codgeo <- paste0(data$Code.du.département, data$ Code.de.la.commune)
  
  # do feat engineering
  cat("Summarise data \n")
  ouput <- data %>%
    
    # group by
    group_by(codgeo) %>%
    
    # count b.vote
    summarise(Nb.b.vote = n(),
              codgeo = unique(codgeo),
              Code.du.département = unique(Code.du.département),
              Libellé.de.la.commune = unique(Libellé.de.la.commune)) %>% 
    
    # apply sum to candidates and main columns
    inner_join(
      
      data %>%
        
        group_by(codgeo) %>%
        
        summarise_at(c(cols_to_keep, candidates), sum, na.rm = TRUE)
      )
    
  # compute score %
  ouput[candidates] <- ouput[candidates]/ouput$Exprimés*100
  
  # return
  ouput
  
}
