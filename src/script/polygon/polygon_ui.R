

# --------------------------------------------------------------------------------
# Shiny module UI
# --------------------------------------------------------------------------------

# -- hide/show checkbox
hide_show_UI <- function(id){
  
  # -- namespace
  ns <- NS(id)
  
  # -- ui
  uiOutput(ns("hide_show"))
  
}


# -- available geojson files
geojson_UI <- function(id){
  
  # -- namespace
  ns <- NS(id)
  
  # -- ui
  uiOutput(ns("geojson"))
  
}


# -- warning dataset
warning_dataset_UI <- function(id){
  
  # -- namespace
  ns <- NS(id)
  
  # -- ui
  uiOutput(ns("warning_dataset"))
  
}


# -- warning geojson
warning_geojson_UI <- function(id){
  
  # -- namespace
  ns <- NS(id)
  
  # -- ui
  uiOutput(ns("warning_geojson"))
  
}


# -- warning perfo
warning_perfo_UI <- function(id){
  
  # -- namespace
  ns <- NS(id)
  
  # -- ui
  uiOutput(ns("warning_perfo"))
  
}


# -- filter_by_dep
filters_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  uiOutput(ns("filter_panel"))
  
}
