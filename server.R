

# --------------------------------------------------------------------------------
# Shiny: server logic of the Shiny web application
# --------------------------------------------------------------------------------
 
# -- Library
library(shiny)
library(shinyWidgets)
library(dplyr)
library(stringr)
library(geojsonio)


# -- Source scripts
cat("Source code from:", path$script, " \n")
for (nm in list.files(path$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
{
  source(nm, encoding = 'UTF-8')
}
rm(nm)


# -- Define server logic

shinyServer(
  function(input, output, session){
    
    # *******************************************************************************************************
    # DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
    # *******************************************************************************************************
    
    DEBUG <<- TRUE
    
    # if(DEBUG){
    #   
    #   source(file.path(path$script, "map/map_server.R"))
    #   source(file.path(path$script, "polygon/polygon_server.R"), encoding = 'UTF-8')
    #   
    # }
    
    # *******************************************************************************************************
    # DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
    # *******************************************************************************************************
    
    # analytics
    log_event(session_id = session$token, event = "main_server_start", timestamp = getTimestamp())
    
    
    # -------------------------------------
    # Communication objects
    # -------------------------------------
    
    # -- declare r communication object
    r <- reactiveValues()
    
    # -- loaded dataset (exposed to check if filters can be displayed)
    r$dataset <- reactiveVal(NULL)
    
    
    # ----------------------------------------------------------------------
    # Launch module servers
    # ----------------------------------------------------------------------
    
    # -- the map
    map_Server(id = "map", r = r, path = path)
    
    # -- polygon
    polygon_Server(id = "polygon", r = r, path = path)
    
    # -- election servers
    presidentielles_Server(id = "presidentielles", r = r, path = path)
    legislatives_Server(id = "legislatives", r = r, path = path)
    europeennes_Server(id = "europeennes", r = r, path = path)
    
    # -- analytics
    analytics_Server(id = "analytics", r = r, path = path)
    
  }
)
