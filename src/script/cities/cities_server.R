

# --------------------------------------------------------------------------------
# Shiny module: flights
# --------------------------------------------------------------------------------

# -- Library
library(geojsonio)


# -------------------------------------
# Server logic
# -------------------------------------

cities_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    cat("-- [cities] Starting module server... \n")
    
    # get namespace
    ns <- session$ns
    
    # -- declare communication objects
    
    # Listen to this to know when geojson data is loaded from file
    r$raw_data_map <- reactiveVal(NULL)
    
    # Feed this with additional @data cols to use for map
    r$data_map <- reactiveVal(NULL)
    
    # Feed this to apply filters
    r$filter_by_name <- reactiveVal(NULL)
    filter_by_dep <- reactiveVal(NULL)
    filter_by_name <- reactiveVal(NULL)
    color_mode <- reactiveVal(NULL)
    
    filtered_map <- reactiveVal(NULL)
    
    # -- declare objects
    list_dep <- reactiveVal(NULL)
    
    
    # -------------------------------------
    # Observe r$proxymap
    # -------------------------------------
    
    observeEvent(r$proxymap, {
      
      cat("Proxymap is now available \n")
      
      # -- Load geojson data
      if(!exists("raw_data_map")){
        
        cat("Loading geojson file... \n")
        geojson <- geojson_read(file.path(path$resource, "a-com2022.json"), what = "sp")
        cat("Loading geojson file done! \n")
        
        if(DEBUG){
          raw_data_map <<- geojson
        }
        
        # store
        r$raw_data_map(geojson)
        
      } else {
        
        r$raw_data_map(raw_data_map)
        
      }
      
      # store list dept
      list_dep(c("All", unique(r$raw_data_map()@data$dep)))
      
      
    })
    
    
    # -------------------------------------
    # Observe r$data_map()
    # -------------------------------------
    
    observeEvent(r$data_map(), {
      
      cat("Data_map is available \n")
      
      # setup filters
      cat("Update filters with choices \n")
      updateSelectizeInput(session, "filter_by_dep", choices = list_dep(), server = TRUE)
      updateSelectizeInput(session, "filter_by_name", choices = r$filter_by_name(), server = TRUE)
    
    })

    
    # -------------------------------------
    # Observe filters
    # -------------------------------------
    
    observeEvent(input$submit_filters, {
      
      req(input$filter_by_dep)
      
      cat("New filters submitted : \n")
      cat("- by dep =", input$filter_by_dep, "\n")
      
      if(!"All" %in% input$filter_by_dep){
        
        tmp_map <- r$data_map()
        tmp_map <- tmp_map[tmp_map@data$dep %in% input$filter_by_dep, ]
        
        filtered_map(tmp_map)
      } else {
        
        filtered_map(r$data_map())
        
      }
      
      
      filter_by_name(input$filter_by_name)
      color_mode(input$color_mode)
      
    })
    
    
    # -------------------------------------
    # Observe
    # -------------------------------------
    
    observeEvent({filtered_map()
      filter_by_name()
      color_mode()}, {
                    
      cat("New filtered map is available \n")
      
      filtered_map <- filtered_map()
      col_name <- filter_by_name()
      
      cat("Update map Polygons... \n ")
      cat("- col_name = ", col_name, "\n")
      
      
      cat("Building labels \n")
      labels <- sprintf(
        "<strong>%s</strong><br/>%s",
        filtered_map@data$libgeo, paste("Résultat = ", round(filtered_map@data[, (colnames(filtered_map@data) %in% col_name)], digits = 2), "%")
      ) %>% lapply(htmltools::HTML)
      
      cat("Building color palette \n")
      max <- 100
      if(color_mode()){
        cat("Compute % max \n")
        max <- max(filtered_map@data[col_name], na.rm = TRUE)}
      
      pal <- makePalette(min = 0, max = max)
      
      cat("Add / Update polygons \n")
      
      r$proxymap %>%
        clearGroup("cities") %>%
        addPolygons(data = filtered_map, 
                    weight = 1, color = ~pal(filtered_map[[col_name]]),
                    fillColor = ~pal(filtered_map[[col_name]]), fillOpacity = 0.8,
                    group = "cities", label = labels)
      
    })

    
    # -------------------------------------
    # Observe hide / show
    # -------------------------------------
    
    observeEvent(input$submit_hide_show, {

      # checkbox marked
      if(input$submit_hide_show){

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

