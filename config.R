


# constants
COLS_TO_SUM <- c("Inscrits", 
                 "Abstentions", 
                 "Votants", 
                 "Blancs", 
                 "Nuls", 
                 "Exprimés")


COL_CLASSES_BEFORE_CANDIDATES <- c("Code.du.département" = "character",
                                   "Libellé.du.département" = "character",
                                   "Code.de.la.circonscription" = "character",
                                   "Libellé.de.la.circonscription" = "character",
                                   "Code.de.la.commune" = "character",
                                   "Libellé.de.la.commune" = "character",
                                   "Code.du.b.vote" = "character",
                                   "Inscrits" = "numeric",
                                   "Abstentions" = "numeric",
                                   "X..Abs.Ins" = "numeric",
                                   "Votants" = "numeric",
                                   "X..Vot.Ins" = "numeric",
                                   "Blancs" = "numeric",
                                   "X..Blancs.Ins" = "numeric",
                                   "X..Blancs.Vot" = "numeric",
                                   "Nuls" = "numeric",
                                   "X..Nuls.Ins" = "numeric",
                                   "X..Nuls.Vot" = "numeric",
                                   "Exprimés" = "numeric",
                                   "X..Exp.Ins" = "numeric",      
                                   "X..Exp.Vot" = "numeric")


COL_CLASSES_BEFORE_CANDIDATES_TMP <- c("Code.du.département" = "character",
                                       "Libellé.du.département" = "character",
                                       "Code.de.la.commune" = "character",
                                       "Libellé.de.la.commune" = "character",
                                       "Etat saisie" = "character",
                                       "Inscrits" = "numeric",
                                       "Abstentions" = "numeric",
                                       "X..Abs.Ins" = "numeric",
                                       "Votants" = "numeric",
                                       "X..Vot.Ins" = "numeric",
                                       "Blancs" = "numeric",
                                       "X..Blancs.Ins" = "numeric",
                                       "X..Blancs.Vot" = "numeric",
                                       "Nuls" = "numeric",
                                       "X..Nuls.Ins" = "numeric",
                                       "X..Nuls.Vot" = "numeric",
                                       "Exprimés" = "numeric",
                                       "X..Exp.Ins" = "numeric",      
                                       "X..Exp.Vot" = "numeric")


COL_CLASSES_CANDIDATES_PRESIDENTIELLE <- c("N.Panneau" = "numeric",
                                           "Sexe" = "character",
                                           "Nom" = "character",
                                           "Prénom" = "character",
                                           "Voix" = "numeric",
                                           "X..Voix.Ins" = "numeric",
                                           "X..Voix.Exp" = "numeric")


COL_CLASSES_CANDIDATES_LEGISLATIVES <- c("N.Panneau" = "numeric",
                                         "Sexe" = "character",
                                         "Nom" = "character",
                                         "Prénom" = "character",
                                         "Nuance" = "character",
                                         "Voix" = "numeric",
                                         "X..Voix.Ins" = "numeric",
                                         "X..Voix.Exp" = "numeric")


LEG_COLS_TO_DROP <- c("X..Abs.Ins",
                      "X..Vot.Ins",
                      "X..Blancs.Ins",
                      "X..Blancs.Vot",
                      "X..Nuls.Ins", 
                      "X..Nuls.Vot",
                      "X..Exp.Ins",
                      "X..Exp.Vot",
                      "X..Voix.Ins",
                      "X..Voix.Exp")


# -- add
COLS_TO_ADD <- c("Code.de.la.circonscription",
                 "Libellé.de.la.circonscription",
                 "Code.du.b.vote")


# ------------------------------------------------------------------------------
# Régions
# ------------------------------------------------------------------------------

# -- regions
REGION_AUVERGNE_RHONE_ALPES <- c("Ain", 
                                 "Ardèche", 
                                 "Drôme", 
                                 "Isère", 
                                 "Loire", 
                                 "Rhône", 
                                 "Savoie", 
                                 "Haute-Savoie", 
                                 "Allier", 
                                 "Cantal", 
                                 "Haute-Loire", 
                                 "Puy-de-Dôme")


REGION_BOURGOGNE_FRANCHE_COMTE <- c("Côte-d'Or", 
                                    "Nièvre", 
                                    "Saône-et-Loire", 
                                    "Yonne", 
                                    "Doubs", 
                                    "Jura", 
                                    "Haute-Saône", 
                                    "Territoire de Belfort")


REGION_BRETAGNE <- c("Côtes-d'Armor", 
                     "Finistère", 
                     "Ille-et-Vilaine",
                     "Morbihan")


REGION_CENTRE_VAL_DE_LOIRE <- c("Cher",
                                "Eure-et-Loir",
                                "Indre",
                                "Indre-et-Loire", 
                                "Loir-et-Cher",
                                "Loiret")


REGION_CORSE <- c("Corse-du-Sud",
                  "Haute-Corse")


REGION_GRAND_EST <- c("Bas-Rhin",
                      "Haut-Rhin",
                      "Ardennes", 
                      "Aube",
                      "Marne",
                      "Haute-Marne",
                      "Meurthe-et-Moselle", 
                      "Meuse",
                      "Moselle", 
                      "Vosges")


REGION_HAUTS_DE_FRANCE <- c("Nord",
                            "Pas-de-Calais",
                            "Aisne",
                            "Oise",
                            "Somme")


REGION_ILE_DE_FRANCE <- c("Paris",
                          "Seine-et-Marne", 
                          "Yvelines", 
                          "Essonne", 
                          "Hauts-de-Seine", 
                          "Seine-Saint-Denis",
                          "Val-de-Marne",
                          "Val-d'Oise")


REGION_NORMANDIE <- c("Calvados", 
                      "Manche",
                      "Orne",
                      "Eure",
                      "Seine-Maritime")


REGION_NOUVELLE_AQUITAINE <- c("Dordogne", 
                               "Gironde", 
                               "Landes", 
                               "Lot-et-Garonne",
                               "Pyrénées-Atlantiques",
                               "Corrèze", 
                               "Creuse",
                               "Haute-Vienne",
                               "Charente", 
                               "Charente-Maritime",
                               "Deux-Sèvres",
                               "Vienne")


REGION_OCCITANIE <- c("Aude",
                      "Gard", 
                      "Hérault",
                      "Lozère",
                      "Pyrénées-Orientales",
                      "Ariège", 
                      "Aveyron", 
                      "Haute-Garonne", 
                      "Gers", 
                      "Lot", 
                      "Hautes-Pyrénées", 
                      "Tarn",
                      "Tarn-et-Garonne")


REGION_PAYS_DE_LA_LOIRE <- c("Pays de la Loire",
                             "Loire-Atlantique", 
                             "Maine-et-Loire", 
                             "Mayenne",
                             "Sarthe",
                             "Vendée")


REGION_PROVENCE_ALPES_CODE_D_AZUR <- c("Alpes-de-Haute-Provence", 
                                       "Hautes-Alpes", 
                                       "Alpes-Maritimes", 
                                       "Bouches-du-Rhône", 
                                       "Var",
                                       "Vaucluse")


# ------------------------------------------------------------------------------
# Départements
# ------------------------------------------------------------------------------

LISTE_DES_DEPARTEMENTS <- c("Ain",
                            "Aisne",
                            "Allier",
                            "Alpes-de-Haute-Provence",
                            "Hautes-Alpes",
                            "Alpes-Maritimes",
                            "Ardèche",
                            "Ardennes",
                            "Ariège",
                            "Aube",
                            "Aude",
                            "Aveyron",
                            "Bouches-du-Rhône",
                            "Calvados",
                            "Cantal",
                            "Charente",
                            "Charente-Maritime",
                            "Cher",
                            "Corrèze",
                            "Corse-du-Sud",
                            "Haute-Corse",
                            "Côte-d'Or",
                            "Côtes-d'Armor",
                            "Creuse",
                            "Dordogne",
                            "Doubs",
                            "Drôme",
                            "Eure",
                            "Eure-et-Loir",
                            "Finistère",
                            "Gard",
                            "Haute-Garonne",
                            "Gers",
                            "Gironde",
                            "Hérault",
                            "Ille-et-Vilaine",
                            "Indre",
                            "Indre-et-Loire",
                            "Isère",
                            "Jura",
                            "Landes",
                            "Loir-et-Cher",
                            "Loire",
                            "Haute-Loire",
                            "Loire-Atlantique",
                            "Loiret",
                            "Lot",
                            "Lot-et-Garonne",
                            "Lozère",
                            "Maine-et-Loire",
                            "Manche",
                            "Marne",
                            "Haute-Marne",
                            "Mayenne",
                            "Meurthe-et-Moselle",
                            "Meuse",
                            "Morbihan",
                            "Moselle",
                            "Nièvre",
                            "Nord",
                            "Oise",
                            "Orne",
                            "Pas-de-Calais",
                            "Puy-de-Dôme",
                            "Pyrénées-Atlantiques",
                            "Hautes-Pyrénées",
                            "Pyrénées-Orientales",
                            "Bas-Rhin",
                            "Haut-Rhin",
                            "Rhône",
                            "Haute-Saône",
                            "Saône-et-Loire",
                            "Sarthe",
                            "Savoie",
                            "Haute-Savoie",
                            "Paris",
                            "Seine-Maritime",
                            "Seine-et-Marne",
                            "Yvelines",
                            "Deux-Sèvres",
                            "Somme",
                            "Tarn",
                            "Tarn-et-Garonne",
                            "Var",
                            "Vaucluse",
                            "Vendée",
                            "Vienne",
                            "Haute-Vienne",
                            "Vosges",
                            "Yonne",
                            "Territoire de Belfort",
                            "Essonne",
                            "Hauts-de-Seine",
                            "Seine-Saint-Denis",
                            "Val-de-Marne",
                            "Val-d'Oise",
                            "Guadeloupe",
                            "Martinique",
                            "Guyane",
                            "La Réunion",
                            "Mayotte",
                            "Nouvelle-Calédonie",
                            "Polynésie française",
                            "Saint-Pierre-et-Miquelon",
                            "Saint-Martin/Saint-Barthélemy",
                            "Français établis hors de France")
