

# Shiny: server logic of the Shiny web application

# -- Library

library(shiny)
library(shinyWidgets)

library(dplyr)
library(stringr)

# -- Declare path

path <- list(project = "./",
             script = "./src/script",
             dictionary = "./src/dictionary",
             resource = "./src/resource",
             data = "./data")


# -- Source scripts

cat("Source code from:", path$script, " \n")
for (nm in list.files(path$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
{
  source(nm, encoding = 'UTF-8')
}
rm(nm)


# Define server logic

shinyServer(
  function(input, output){
    
    # *******************************************************************************************************
    # DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
    # *******************************************************************************************************
    
    DEBUG <<- FALSE
    
    if(DEBUG){
      
      source(file.path(path$script, "map/map_server.R"))
      source(file.path(path$script, "cities/cities_server.R"), encoding = 'UTF-8')
      
    }
    
    # *******************************************************************************************************
    # DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
    # *******************************************************************************************************
    
    # declare r communication object
    r <- reactiveValues()
    
    # ----------------------------------------------------------------------
    # - dataset: from data module, contains the data by candidate / cities
    
    # - filter_by_name
    
    # - proxymap:
    # - map_center:
    # ----------------------------------------------------------------------
    
    
    # data
    data_Server(id = "data", r = r, path = path)
    
    # map
    map_Server(id = "map", r = r, path = path)
    
    # polygon city-level
    cities_Server(id = "cities", r = r, path = path)
    
  }
)
