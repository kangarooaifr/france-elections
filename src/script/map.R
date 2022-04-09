
# --------------------------------------------------------------------------------
# Shiny module: map
# --------------------------------------------------------------------------------

# -- Library

# -- Source dependencies


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
search_Input <- function(id) {
  
  # namespace
  ns <- NS(id)
  
  # UI
  wellPanel(
    
    # search input
    searchInput(ns("search"), label = "Search", value = "")
    
  )
  
}


# -------------------------------------
# Server logic
# -------------------------------------

map_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    cat("-- Starting map_Server... \n")
    
    # -------------------------------------
    # Outputs
    # -------------------------------------
    
    # -- Output: map
    output$map <- renderLeaflet({
      leaflet() %>%
        
        # Add default OpenStreetMap map tiles
        addTiles(group = "OSM") %>%
        
        # Set view point
        #setView(lng = -87.60, lat = 41.86, zoom = 10)
        setView(lng = 1.7191036, lat = 46.71109, zoom = 6) %>%
        
        # Add National Geographic
        #addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
        addProviderTiles(providers$CartoDB.Positron)
      
    })
    
    # -- Declare proxy map
    r$proxymap <- leafletProxy('map')
    
    
    # -------------------------------------
    # Event observers
    # -------------------------------------
    
    
    # -- Observe map center
    observeEvent(input$map_center, {
      
      # cache map center
      r$map_center <- input$map_center
      
    })
    
    
    # -- Observe search
    observeEvent(input$search, {
      
      # check value
      req(input$search)

      # trace      
      cat("search input =", input$search, "\n")
      
      # get search result
      res <- mygeocode(input$search)
      
      # update map
      if (!is.null(res)){
        leafletProxy('map') %>%
          flyTo('map', lng = res[1], lat = res[2], zoom = 12)
      }
      else{
        showNotification("No result found", type = "error")
      }
      
      
    })
    
  })
}

