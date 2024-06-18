

europeennes_2024_circo <- function(){
  
  # -- param
  pattern <- "europeennes"
  
  # -- read data
  dataset <- readr::read_delim("data/Europeennes_2024_circonscription.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
  
  # -- define
  cols_before <- c("Code département",
                   "Libellé département",
                   "Code circonscription législative",
                   "Libellé circonscription législative",
                   "Inscrits",
                   "Votants",
                   "% Votants",
                   "Abstentions",
                   "% Abstentions",
                   "Exprimés",
                   "% Exprimés/inscrits",
                   "% Exprimés/votants",
                   "Blancs",
                   "% Blancs/inscrits",
                   "% Blancs/votants",
                   "Nuls",
                   "% Nuls/inscrits",
                   "% Nuls/votants")
  
  cols_candidate <- c("Numéro de panneau",
                      "Nuance liste",
                      "Libellé abrégé de liste",
                      "Libellé de liste",
                      "Voix",
                      "% Voix/inscrits",
                      "% Voix/exprimés",
                      "Sièges")
  
  RAW_COLS_TO_DROP <- c("% Votants",
                        "% Abstentions",
                        "% Exprimés/inscrits",
                        "% Exprimés/votants",
                        "% Blancs/inscrits",
                        "% Blancs/votants",
                        "% Nuls/inscrits",
                        "% Nuls/votants",
                        "% Voix/inscrits",
                        "% Voix/exprimés",
                        "Sièges")
  
  # -- copy
  data <- dataset
  
  # -- prepare
  # warning: this line does not work   colnames(data) <- c(names(cols_before), names(cols_candidate))
  # Replace by this >> colnames(data) <- c(cols_before, cols_candidate)
  # dataset_by_candidate <- prepare_by_candidates2(dataset, pattern, cols_before, cols_candidate)
  
  # -- fix
  data$`Nom.Tête.de.Liste` <- data$`Libellé abrégé de liste 1`
  data$`Code circonscription législative` <- substr(data$`Code circonscription législative`, nchar(data$`Code circonscription législative`) - 2 + 1, nchar(data$`Code circonscription législative`))
  data$codgeo.circonscription <- paste0(data[[1]], str_pad(data[[3]], 3, pad = "0"))
  
  # -- rename
  colnames(data) <- c("Code.du.département",
                      "Libellé.du.département",
                      "Code.de.la.circonscription",
                      "Libellé.de.la.circonscription",
                      "Inscrits",
                      "Votants",
                      "Abstentions",
                      "Exprimés",
                      "Blancs",
                      "Nuls",
                      "N.Liste",
                      "Nuance liste",
                      "Libellé.Abrégé.Liste",
                      "Libellé.Etendu.Liste",
                      "Voix",
                      "Nom.Tête.de.Liste",
                      "codgeo.circonscription")
  
  # -- save
  save_csv(path = "data/prepared", file = "Europeennes_2024_circonscription.txt", data)
  
}
