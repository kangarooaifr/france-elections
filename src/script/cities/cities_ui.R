

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
    checkboxInput(ns("submit_hide_show"), label = "Hide / Show", value = TRUE, width = NULL)
    
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
    selectizeInput(ns("filter_by_dep"), label = "Departement", choices = NULL, multiple = TRUE),
    
    # color palette
    checkboxInput(ns("color_mode"), label = "Color : activate % max", value = TRUE, width = NULL),
    
    actionButton(ns("submit_filters"), label = "Submit")
  )
  
}
