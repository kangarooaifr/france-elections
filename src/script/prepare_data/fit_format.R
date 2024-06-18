

fit_format <- function(data, cols_to_add, cols_to_delete){
  
  cat("*** Fitting data format *** \n")
  
  # delete
  cat("- Drop cols :", cols_to_delete, "\n")
  data[cols_to_delete] <- NULL
  
  # add
  cat("- Adding cols :", cols_to_add, "\n")
  data[cols_to_add] <- 0
  
  # reorder......
  cols_order <- c("Code.du.département",
                  "Libellé.du.département",
                  "Code.de.la.circonscription",
                  "Libellé.de.la.circonscription",
                  "Code.de.la.commune",
                  "Libellé.de.la.commune",
                  "Code.du.b.vote",
                  "Inscrits",
                  "Abstentions",
                  "X..Abs.Ins",
                  "Votants",
                  "X..Vot.Ins",
                  "Blancs",
                  "X..Blancs.Ins",
                  "X..Blancs.Vot",
                  "Nuls",
                  "X..Nuls.Ins",
                  "X..Nuls.Vot",
                  "Exprimés",
                  "X..Exp.Ins",      
                  "X..Exp.Vot",
                  "N.Panneau",
                  "Sexe",
                  "Nom",
                  "Prénom",
                  "Voix",
                  "X..Voix.Ins",
                  "X..Voix.Exp",
                  "N.Panneau.1",
                  "Sexe.1",
                  "Nom.1",
                  "Prénom.1",
                  "Voix.1",
                  "X..Voix.Ins.1",
                  "X..Voix.Exp.1")
  
  # order
  data <- data[, cols_order]
  
  # return
  data
  
}
