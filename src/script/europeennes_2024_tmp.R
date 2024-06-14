# 
# 
# # --
# pattern <- "europeennes"
# 
# # -- read data
# dataset <- readr::read_csv("data/resultats-temporaires-par-commune.csv", skip = 1)
# 
# raw_cols <- colnames(dataset)
# 
# cols_before <- c("Code département",
#                  "Libellé département",
#                  "Code commune",
#                  "Libellé commune",
#                  "Inscrits",
#                  "Votants",
#                  "% Votants",
#                  "Abstentions",
#                  "% Abstentions",
#                  "Exprimés",
#                  "% Exprimés/inscrits",
#                  "% Exprimés/votants",
#                  "Blancs",
#                  "% Blancs/inscrits",
#                  "% Blancs/votants",
#                  "Nuls",
#                  "% Nuls/inscrits",
#                  "% Nuls/votants")
# 
# cols_candidate <- c("Numéro de panneau",
#                     "Nuance liste",
#                     "Libellé abrégé de liste",
#                     "Libellé de liste",
#                     "Voix",
#                     "% Voix/inscrits",
#                     "% Voix/exprimés",
#                     "Sièges")
# 
# RAW_COLS_TO_DROP <- c("% Votants",
#                       "% Abstentions",
#                       "% Exprimés/inscrits",
#                       "% Exprimés/votants",
#                       "% Blancs/inscrits",
#                       "% Blancs/votants",
#                       "% Nuls/inscrits",
#                       "% Nuls/votants",
#                       "% Voix/inscrits",
#                       "% Voix/exprimés",
#                       "Sièges")
# 
# # -- prepare
# # warning: this line does not work   colnames(data) <- c(names(cols_before), names(cols_candidate))
# # Replace by this >> colnames(data) <- c(cols_before, cols_candidate)
# # dataset_by_candidate <- prepare_by_candidates2(dataset, pattern, cols_before, cols_candidate)
# 
# 
# # -- Code département
# # Fix code 1,2,3... 9 because it should be 01,02...
# 
# data[data$`Code département` == "1", ]$`Code département` <- "01"
# data[data$`Code département` == "2", ]$`Code département` <- "02"
# data[data$`Code département` == "3", ]$`Code département` <- "03"
# data[data$`Code département` == "4", ]$`Code département` <- "04"
# data[data$`Code département` == "5", ]$`Code département` <- "05"
# data[data$`Code département` == "6", ]$`Code département` <- "06"
# data[data$`Code département` == "7", ]$`Code département` <- "07"
# data[data$`Code département` == "8", ]$`Code département` <- "08"
# data[data$`Code département` == "9", ]$`Code département` <- "09"
# 
# 
# # -- Code commune
# # Fix code 1001 because it should be 1 (they added departement before)
# 
# data$`Code commune` <- substr(data$`Code commune`, nchar(data$`Code commune`) - 3 + 1, nchar(data$`Code commune`))
# 
# colnames(data) <- c("Code.du.département",
#                     "Libellé.du.département",
#                     "Code.de.la.commune",
#                     "Libellé.de.la.commune",
#                     "Inscrits",
#                     "Votants",
#                     "Abstentions",
#                     "Exprimés",
#                     "Blancs",
#                     "Nuls",
#                     "N.Liste",
#                     "Nuance liste",
#                     "Libellé.Abrégé.Liste",
#                     "Libellé.Etendu.Liste",
#                     "Voix",
#                     "codgeo.commune",
#                     "codgeo.circonscription",
#                     "Nom.Tête.de.Liste")
# 
