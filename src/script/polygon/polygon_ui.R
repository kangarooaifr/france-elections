

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

# -- warning
warning_perfo_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  #UI
  uiOutput(ns("warning_perfo"))
  
}


# -- filter_by_dep
filters_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  uiOutput(ns("filter_panel"))
  
}
