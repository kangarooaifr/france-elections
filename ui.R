
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
        menuItem("Carte", tabName = "map", icon = icon("map"), selected = TRUE)
    )
)


# -- Define Body UI

body <- dashboardBody(
    
    tabItems(
    
        tabItem(tabName = "map",
                
                fluidRow(
                    column(width = 2,
                           select_dataset_UI("data"),
                           geojson_UI("cities"),
                           filters_UI("cities"),
                           hide_show_UI("cities"),
                           map_search_Input("map")
                           ),
                    column(width = 10,
                           map_UI("map"),br(),
                           p("© Philippe PERET - KANGAROO.AI | Version 1.1 | Source : https://www.data.gouv.fr/fr/pages/donnees-des-elections/")
                           )
                )
                
        )
    )
)


# -- Put them together into a dashboard

dashboardPage(
    
    dashboardHeader(title = "Elections France"),
    sidebar,
    body
    
)

