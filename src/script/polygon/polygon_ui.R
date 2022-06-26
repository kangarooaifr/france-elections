

# --------------------------------------------------------------------------------
# Shiny module:
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


# -- available geoJson files
geojson_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # init buttons (toggle in server)
  wellPanel(
    uiOutput(ns("select_geojson")),
    uiOutput(ns("action_geojson")))
  
}

# -- warning
warning_dataset_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  #UI
  uiOutput(ns("warning_dataset"))
  
}

# -- warning
warning_geojson_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  #UI
  uiOutput(ns("warning_geojson"))
  
}


# -- filter_by_dep
filters_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  uiOutput(ns("filter_panel"))
  
  
  # wellPanel(
  #   
  #   # warnings
  #   uiOutput(ns("is_dataset_loaded")),
  #   uiOutput(ns("is_geojson_loaded")),
  #   
  #   # init (empty choices)
  #   selectizeInput(ns("filter_by_name"), label = "Candidat", choices = NULL),
  #   
  #   # input (empty choices)
  #   selectizeInput(ns("filter_by_dep"), label = "Département", choices = NULL, multiple = TRUE),
  #   
  #   # color palette
  #   checkboxInput(ns("color_mode_min"), label = "Couleurs : activer % min", value = TRUE, width = NULL),
  #   checkboxInput(ns("color_mode_max"), label = "Couleurs : activer % max", value = TRUE, width = NULL),
  #   p("Calcul des couleurs en fonction des % du candidat dans la zone sélectionnée (sinon de 0 à 100%)"),
  #   
  #   # opacity
  #   sliderInput(
  #     inputId = ns("select_opacity"),
  #     label = "Opacité",
  #     min = 0,
  #     max = 100,
  #     value = 80,
  #     step = 5),
  #   
  #   actionButton(ns("submit_filters"), label = "Afficher")
  # )
  
}
