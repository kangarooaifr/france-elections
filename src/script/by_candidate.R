

library(dplyr)

summary_by_candidate <- function(data, n_cand){
  
  cat("Computing summary by candidate with n_cand =", n_cand, "\n")
  
  ouput <- data %>%
    
    # filter by candidate
    filter(N.Panneau == n_cand) %>%
    
    # group by city
    group_by(Libellé.de.la.commune) %>%
    
    # summarise
    summarise(nb.b.vote = n(),
              Inscrits = sum(Inscrits),
              Abstentions = sum(Abstentions),
              Votants = sum(Votants),
              Blancs = sum(Blancs),
              Nuls = sum(Nuls),
              Exprimés = sum(Exprimés),
              N.Panneau = unique(N.Panneau),
              Nom = unique(Nom),
              Prénom = unique(Prénom),
              Voix = sum(Voix),
              X.Voix.Exp = sum(Voix) / sum(Exprimés))
  
}
