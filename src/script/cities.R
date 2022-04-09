

# --------------------------------------------------------------------------------
# Shiny module: flights
# --------------------------------------------------------------------------------

# -- Library
library(geojsonio)

# -- Source dependencies


# -------------------------------------
# UI items section
# -------------------------------------

# -- Where gone checkbox
cities_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  wellPanel(
    
    # hide / show checkbox
    checkboxInput(ns("submit_cities"), label = "cities", value = FALSE, width = NULL)
    
  )
  
}

# -- Where gone checkbox
dep_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  wellPanel(
    
    # hide / show checkbox
    #uiOutput(ns("select_dep"))
    
    # in ui
    selectizeInput(ns("select_dep"), label = "Departement", choices = NULL, multiple = TRUE)
    
  )
  
}


# -------------------------------------
# Server logic
# -------------------------------------

cities_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    # get namespace
    ns <- session$ns
    
    selected_dep <- reactiveVal(NULL)
    filtered_map <- reactiveVal(NULL)
    

    if(!exists("data_Map")){
      cat("Loading geojson file... \n")
      data_Map <- geojson_read(file.path(path$resource, "a-com2022.json"), what = "sp")
      cat("Loading geojson file done! \n")
      
      if(DEBUG){
        data_Map <<- data_Map
      }
      
    }
    
    list_dep <- c("All", unique(data_Map@data$dep))


    
    observeEvent({r$data_by_cand()
      filtered_map()}, {
      
      if(dim(filtered_map()@data)[1] != 0){
      
      cat("Update map Polygons... \n ")
      
      data_cand <- r$data_by_cand()
      
      labels <- sprintf(
        "<strong>%s</strong><br/>%s",
        filtered_map()@data$libgeo, paste("Résultat = ", round(filtered_map()@data$result * 100, digits = 2), "%")
      ) %>% lapply(htmltools::HTML)
    
      pal <- makePalette(min = 0, max = max(filtered_map()@data$result, na.rm = TRUE))
      
      r$proxymap %>% 
        clearGroup(group = "cities") %>% 
        addPolygons(data = filtered_map(), 
                    weight = 1, color = ~pal(result),
                    fillColor = ~pal(result), fillOpacity = 0.8,
                    group = "cities", label = labels)
      
      }
      
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    
    # -------------------------------------
    # Outputs
    # -------------------------------------
    
    # output$select_dep <- renderUI({
    #   selectInput(ns("select_dep"), label = "Departement", choices = list_dep, selected = NULL, width = NULL)
    # })
    
    updateSelectizeInput(session, "select_dep", choices = list_dep, server = TRUE)
    
    
    observeEvent({input$select_dep 
      r$data_by_cand()}, {
        
        cat("Selected dep =", input$select_dep, "\n")
        

        if(length(input$select_dep) == 0){
          
          tmp <- NULL
          
        } else {
          
          if(input$select_dep != "All"){
            
            tmp <- data_Map[data_Map@data$dep %in% input$select_dep, ]
            
          } else {
            
            tmp <- data_Map
            
          }
          
          tmp@data$result <- r$data_by_cand()$X.Voix.Exp[match(tmp@data$libgeo, r$data_by_cand()$Libellé.de.la.commune)]
          
        }
      
      filtered_map(tmp)
      
      if(DEBUG){
        filtered_map_data <<- tmp
      }
      
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    
    # -------------------------------------
    # Event observers
    # -------------------------------------
    
    # -- Observe checkbox
    observeEvent(input$submit_cities, {

      # checkbox marked
      if(input$submit_cities){

        cat("Show group: cities \n")

        # proxy map
        r$proxymap %>%

          # Show group
          showGroup('cities')

      }else{

        cat("Hide group: cities \n")

        # proxy map
        r$proxymap %>%

          # clear group
          hideGroup('cities')
      }

    }, ignoreInit = TRUE)
    
  })
}

