

# -------------------------------------
# Environment
# -------------------------------------

# -- Path
path <- list(project = "./",
             script = "./src/script",
             dictionary = "./src/dictionary",
             resource = "./src/resource",
             data = "./data",
             data_raw = "./data",
             data_prepared = "./data/prepared",
             analytics = "./analytics")


# -------------------------------------
# External resources
# -------------------------------------

source("E:/Portfolio/R/Projects/france-elections/shinyapp/src/script/load_resource.R")

# -- Columns to aggregate by geocode
COLS_TO_SUM <- load_resource(path$resource, "cols_to_sum.csv", header = FALSE, format = "vector", encoding = "UTF-8")

# -- Columns for a given candidate
COLS_UNIQUE_CIRCO_LEG <- load_resource(path$resource, "cols_unique_circo_leg.csv", header = FALSE, format = "vector", encoding = "UTF-8")
COLS_UNIQUE_CIRCO_PDT <- load_resource(path$resource, "cols_unique_circo_pdt.csv", header = FALSE, format = "vector", encoding = "UTF-8")
COLS_UNIQUE_CIRCO_EUR <- load_resource(path$resource, "cols_unique_circo_eur.csv", header = FALSE, format = "vector", encoding = "UTF-8")

COLS_UNIQUE_COMMUNE_LEG <- load_resource(path$resource, "cols_unique_commune_leg.csv", header = FALSE, format = "vector", encoding = "UTF-8")
COLS_UNIQUE_COMMUNE_PDT <- load_resource(path$resource, "cols_unique_commune_pdt.csv", header = FALSE, format = "vector", encoding = "UTF-8")
COLS_UNIQUE_COMMUNE_EUR <- load_resource(path$resource, "cols_unique_commune_eur.csv", header = FALSE, format = "vector", encoding = "UTF-8")

# -- Columns before the candidates
COL_CLASSES_BEFORE_CANDIDATES <- load_resource(path$resource, "col_classes_before_candidates.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")
COL_CLASSES_BEFORE_CANDIDATES_TMP <- load_resource(path$resource, "col_classes_before_candidates_tmp.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")
COL_CLASSES_BEFORE_CANDIDATES_EUROPEENNES_CIRCO <- load_resource(path$resource, "col_classes_before_candidates_europeennes_circo.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")
COL_CLASSES_BEFORE_CANDIDATES_EUROPEENNES_COMMUNE <- load_resource(path$resource, "col_classes_before_candidates_europeennes_commune.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")

# -- Columns candidate
COL_CLASSES_CANDIDATES_PRESIDENTIELLE <- load_resource(path$resource, "col_classes_candidates_presidentielle.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")
COL_CLASSES_CANDIDATES_LEGISLATIVES <- load_resource(path$resource, "col_classes_candidates_legislatives.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")
COL_CLASSES_CANDIDATES_EUROPEENNES <- load_resource(path$resource, "col_classes_candidates_europeennes.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")

# -- Columns prepared datasets
COL_CLASSES_PREPARED_LEGISLATIVES <- load_resource(path$resource, "col_classes_prepared_legislatives.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")
COL_CLASSES_PREPARED_PRESIDENTIELLE <- load_resource(path$resource, "col_classes_prepared_presidentielle.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")
COL_CLASSES_PREPARED_EUROPEENNES <- load_resource(path$resource, "col_classes_prepared_europeennes.csv", header = FALSE, format = "named_vector", encoding = "UTF-8")

# -- Columns to drop
RAW_COLS_TO_DROP <- load_resource(path$resource, "raw_cols_to_drop.csv", header = FALSE, format = "vector", encoding = "UTF-8")

# -- Columns to add
COLS_TO_ADD <- load_resource(path$resource, "cols_to_add.csv", header = FALSE, format = "vector", encoding = "UTF-8")


# -- Liste des circonscriptions (avec régions et départements)
DEP_REG_CIRCO <- read.csv(file.path(path$resource, "liste_dep_reg_circo.csv"), encoding = "UTF-8")

# -- Liste des départements (codes et libéllés)
LISTE_DEP <- read.csv(file.path(path$resource, "liste_dep.csv"), encoding = "UTF-8")
