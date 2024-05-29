
# --------------------------------------------------------------------------------
# This is the user-interface definition of the Shiny web application
# --------------------------------------------------------------------------------

# -- Library
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)


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
      menuItem("Résultats", tabName = "resultats", icon = icon("map"), selected = TRUE)),
    collapsed = TRUE)


# -- Define Body UI
body <- dashboardBody(
  
    tags$head(includeHTML(("./src/google/google-analytics.html"))),
    
    tabItems(
      
      # -- Presidentielles
      tabItem(tabName = "resultats",
              
              fluidRow(
              
                  column(width = 2,
                         
                         # -- data
                         tabsetPanel(
                           tabPanel("Présidentielles", 
                                    select_dataset_UI("presidentielles")),
                           tabPanel("Législatives", 
                                    select_dataset_UI("legislatives"))),
                         warning_dataset_UI("polygon"),
                         
                         # -- polygons
                         geojson_UI("polygon"),
                         warning_geojson_UI("polygon"),
                         #paypal_btn()
                         ),
                  
                  column(width = 8,
                         map_UI("map"),br(),
                         p("© 2022 Philippe PERET @TheKangarooFactory | Version 2.0.2 | ",
                           a("LinkedIn", href="https://www.linkedin.com/in/philippeperet/"), "|",
                           a("GitHub", href="https://github.com/thekangaroofactory"), "|",
                           a("Data Source", href="https://www.data.gouv.fr/fr/pages/donnees-des-elections/"))),
                  
                  column(width = 2,
                         filters_UI("polygon"),
                         hide_show_UI("polygon"),
                         map_search_Input("map"),
                         warning_perfo_UI("polygon"))))
              
      )
)


# -- Put them together into a dashboard
dashboardPage(
  
  dashboardHeader(title = "France Elections"),
  sidebar,
  body
    
)

