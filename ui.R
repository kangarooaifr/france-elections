
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
      menuItem("Présidentielles", tabName = "presidentielles", icon = icon("map"), selected = TRUE)),
    collapsed = TRUE)


# -- Define Body UI

body <- dashboardBody(
    
    tabItems(
    
        # -- Presidentielles
        tabItem(tabName = "presidentielles",
                
                fluidRow(
                  
                    column(width = 2,
                           select_dataset_UI("data"),
                           geojson_UI("polygon"),
                           paypal_btn()),
                    
                    column(width = 8,
                           map_UI("map"),br(),
                           p("© 2022 Philippe PERET / KANGAROO.AI | Version 1.3 | ",
                           a("LinkedIn", href="https://www.linkedin.com/in/philippeperet/"), "|",
                           a("Source", href="https://www.data.gouv.fr/fr/pages/donnees-des-elections/"))),
                    
                    column(width = 2,
                           filters_UI("polygon"),
                           hide_show_UI("polygon"),
                           map_search_Input("map"))))
    
    
    )
)


# -- Put them together into a dashboard

dashboardPage(
    
    dashboardHeader(title = "France Elections"),
    sidebar,
    body
    
)

