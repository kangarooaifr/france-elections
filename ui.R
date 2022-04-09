
# --------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny web application
# --------------------------------------------------------------------------------

# -- Library

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)

# -- Declare path
path <- list(project = "./",
             script = "./src/script",
             dictionary = "./src/dictionary",
             resource = "./src/resource",
             data = "./data")

# -- source scripts
cat("Source code from:", path$script, " \n")
for (nm in list.files(path$script, full.names = TRUE, recursive = TRUE, include.dirs = FALSE))
{
  source(nm, encoding = 'UTF-8')
}
rm(nm)


# -- Define Sidebar UI

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Map", tabName = "map", icon = icon("map"), selected = TRUE)
    )
)


# -- Define Body UI

body <- dashboardBody(
    
    tabItems(
    
        tabItem(tabName = "map",
                h2("Map"),
                
                fluidRow(
                    column(width = 2,
                           search_Input("map"),
                           cities_UI("cities"),
                           data_UI("data"),
                           dep_UI("cities")
                           ),
                    column(width = 10,
                           map_UI("map")
                           )
                )
                
        )
    )
)


# -- Put them together into a dashboard

dashboardPage(
    
    dashboardHeader(title = "Election Map"),
    sidebar,
    body
    
)

