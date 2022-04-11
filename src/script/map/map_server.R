
# ------------------------------------------------------------------------------
# Shiny module: map
# ------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# Server logic
# -------------------------------------

map_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    cat("-- [map] Starting module server... \n")
    
    # -------------------------------------
    # Outputs
    # -------------------------------------
    
    # -- Output: map
    output$map <- renderLeaflet({
      leaflet() %>%
        
        # Add default OpenStreetMap map tiles
        addTiles(group = "OSM") %>%
        
        # Set view point
        setView(lng = 1.7191036, lat = 46.71109, zoom = 6) %>%
        
        # Add tile
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
    
    
    # -- Observe map_search
    observeEvent(input$map_search, {
      
      # check value
      req(input$map_search)

      # trace      
      cat("map_search input =", input$map_search, "\n")
      
      # get map_search result
      res <- mygeocode(input$map_search)
      
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

