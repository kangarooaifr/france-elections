

# --------------------------------------------------------------------------------
# Shiny module: cities
# --------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# UI items section
# -------------------------------------

# -- hide/show checkbox
hide_show_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  wellPanel(
    
    # input
    checkboxInput(ns("submit_hide_show"), label = "Afficher / Cacher", value = TRUE, width = NULL)
    
  )
  
}


# -- filter_by_dep
filters_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  wellPanel(
    
    # init (empty choices)
    selectizeInput(ns("filter_by_name"), label = "Candidat", choices = NULL),
    
    # input (empty choices)
    selectizeInput(ns("filter_by_dep"), label = "Département", choices = NULL, multiple = TRUE),
    
    # color palette
    checkboxInput(ns("color_mode"), label = "Couleurs : activer % max", value = TRUE, width = NULL),
    p("Calcul des couleurs en fonction du % max du candidat dans la zone sélectionnée (sinon de 0 à 100%)"),
    
    actionButton(ns("submit_filters"), label = "Afficher")
  )
  
}
