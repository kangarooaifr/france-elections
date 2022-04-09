

# Shiny: server logic of the Shiny web application

# -- Library

library(shiny)
library(shinyWidgets)

# -- Dependencies
source("~/Work/R/Library/Read and write/read.data.R")
source("~/Work/R/Library/Read and write/write.data.R")

# -- Declare path
path <- list(project = "./",
             script = "./src/script",
             dictionary = "./src/dictionary",
             resource = "./src/resource",
             data = "./data")


DEBUG <<- TRUE


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
        source(file.path(path$script, "map.R"))
        source(file.path(path$script, "cities.R"), encoding = 'UTF-8')
        
        
        # *******************************************************************************************************
        # DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
        # *******************************************************************************************************
        
        # declare r communication object
        
        # ----------------------------------------------------------------------
        # - whereGone:
        # - proxymap:
        # - map_center:
        # - airports:
        # - flights:
        # ----------------------------------------------------------------------
        
        r <- reactiveValues()
        
        # data
        data_Server(id = "data", r = r, path = path)
        
        # map
        map_Server(id = "map", r = r, path = path)
        
        # polygon city-level
        cities_Server(id = "cities", r = r, path = path)
        
    }
)
