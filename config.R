


# constants
# COLS_TO_SUM <- c("Inscrits", 
#                  "Abstentions", 
#                  "Votants", 
#                  "Blancs", 
#                  "Nuls", 
#                  "Exprimés")

COLS_TO_SUM <- load_resource(path$resource, "cols_to_sum.csv", header = FALSE, format = "vector", encoding = "UTF-8")



# COL_CLASSES_BEFORE_CANDIDATES <- c("Code.du.département" = "character",
#                                    "Libellé.du.département" = "character",
#                                    "Code.de.la.circonscription" = "character",
#                                    "Libellé.de.la.circonscription" = "character",
#                                    "Code.de.la.commune" = "character",
#                                    "Libellé.de.la.commune" = "character",
#                                    "Code.du.b.vote" = "character",
#                                    "Inscrits" = "numeric",
#                                    "Abstentions" = "numeric",
#                                    "X..Abs.Ins" = "numeric",
#                                    "Votants" = "numeric",
#                                    "X..Vot.Ins" = "numeric",
#                                    "Blancs" = "numeric",
#                                    "X..Blancs.Ins" = "numeric",
#                                    "X..Blancs.Vot" = "numeric",
#                                    "Nuls" = "numeric",
#                                    "X..Nuls.Ins" = "numeric",
#                                    "X..Nuls.Vot" = "numeric",
#                                    "Exprimés" = "numeric",
#                                    "X..Exp.Ins" = "numeric",      
#                                    "X..Exp.Vot" = "numeric")


COL_CLASSES_BEFORE_CANDIDATES <- load_resource(path$resource, "col_classes_before_candidates.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")



# COL_CLASSES_BEFORE_CANDIDATES_TMP <- c("Code.du.département" = "character",
#                                        "Libellé.du.département" = "character",
#                                        "Code.de.la.commune" = "character",
#                                        "Libellé.de.la.commune" = "character",
#                                        "Etat saisie" = "character",
#                                        "Inscrits" = "numeric",
#                                        "Abstentions" = "numeric",
#                                        "X..Abs.Ins" = "numeric",
#                                        "Votants" = "numeric",
#                                        "X..Vot.Ins" = "numeric",
#                                        "Blancs" = "numeric",
#                                        "X..Blancs.Ins" = "numeric",
#                                        "X..Blancs.Vot" = "numeric",
#                                        "Nuls" = "numeric",
#                                        "X..Nuls.Ins" = "numeric",
#                                        "X..Nuls.Vot" = "numeric",
#                                        "Exprimés" = "numeric",
#                                        "X..Exp.Ins" = "numeric",      
#                                        "X..Exp.Vot" = "numeric")

COL_CLASSES_BEFORE_CANDIDATES_TMP <- load_resource(path$resource, "col_classes_before_candidates_tmp.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")



# COL_CLASSES_CANDIDATES_PRESIDENTIELLE <- c("N.Panneau" = "numeric",
#                                            "Sexe" = "character",
#                                            "Nom" = "character",
#                                            "Prénom" = "character",
#                                            "Voix" = "numeric",
#                                            "X..Voix.Ins" = "numeric",
#                                            "X..Voix.Exp" = "numeric")

COL_CLASSES_CANDIDATES_PRESIDENTIELLE <- load_resource(path$resource, "col_classes_candidates_presidentielle.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")



# COL_CLASSES_CANDIDATES_LEGISLATIVES <- c("N.Panneau" = "numeric",
#                                          "Sexe" = "character",
#                                          "Nom" = "character",
#                                          "Prénom" = "character",
#                                          "Nuance" = "character",
#                                          "Voix" = "numeric",
#                                          "X..Voix.Ins" = "numeric",
#                                          "X..Voix.Exp" = "numeric")

COL_CLASSES_CANDIDATES_LEGISLATIVES <- load_resource(path$resource, "col_classes_candidates_legislatives.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")




# LEG_COLS_TO_DROP <- c("X..Abs.Ins",
#                       "X..Vot.Ins",
#                       "X..Blancs.Ins",
#                       "X..Blancs.Vot",
#                       "X..Nuls.Ins", 
#                       "X..Nuls.Vot",
#                       "X..Exp.Ins",
#                       "X..Exp.Vot",
#                       "X..Voix.Ins",
#                       "X..Voix.Exp")


LEG_COLS_TO_DROP <- load_resource(path$resource, "leg_cols_to_drop.csv", header = FALSE, format = "vector", encoding = "UTF-8")

# -- add
# COLS_TO_ADD <- c("Code.de.la.circonscription",
#                  "Libellé.de.la.circonscription",
#                  "Code.du.b.vote")


COLS_TO_ADD <- load_resource(path$resource, "cols_to_add.csv", header = FALSE, format = "vector", encoding = "UTF-8")




# -------------------------------------
# Load resources
# -------------------------------------

# -- Liste des circonscriptions (avec régions et départements)
DEP_REG_CIRCO <- read.csv(file.path(path$resource, "liste_dep_reg_circo.csv"), encoding = "UTF-8")

# -- Liste des départements (codes et libéllés)
LISTE_DEP <- read.csv(file.path(path$resource, "liste_dep.csv"), encoding = "UTF-8")



