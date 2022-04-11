
# ------------------------------------------------------------------------------
# Shiny module: map
# ------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# UI items section
# -------------------------------------

# -- Main map
map_UI <- function(id)
{
  
  # namespace
  ns <- NS(id)
  
  # map
  leafletOutput(ns("map"), height = 800)
  
}


# -------------------------------------
# Input items section
# -------------------------------------

# -- Search input form
map_search_Input <- function(id) {
  
  # namespace
  ns <- NS(id)
  
  # UI
  wellPanel(
    
    # search input
    searchInput(ns("map_search"), label = "Recherche", value = ""),
    p("Entrez le nom d'une ville, un département, une région, une adresse.")
    
  )
  
}