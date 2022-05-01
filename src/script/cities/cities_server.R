

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
    color_mode_max <- reactiveVal(NULL)
    color_mode_min <- reactiveVal(NULL)
    color_opacity <- reactiveVal(NULL)
    
    filtered_map <- reactiveVal(NULL)
    
    # -- declare objects
    list_dep <- reactiveVal(NULL)
    
    # list available GeoJsons
    list_geojson <- list("Communes" = "a-com2022.json",
                         "Circonscriptions législatives 2012" = "france-circonscriptions-legislatives-2012.json")
    
    # loaded geojson
    is_loaded_geojson <- reactiveVal(rep(FALSE, length(list_geojson)))

    
    # -------------------------------------
    # Outputs
    # -------------------------------------
    
    # select geojson
    output$select_geojson <- renderUI(selectizeInput(ns("select_geojson"), label = "Contours", choices = list_geojson))
    
    # show hide action button
    output$action_geojson <- renderUI(actionButton(ns("load_geojson"), label = "Charger"))
    
    
    # -------------------------------------
    # Observe load_geojson
    # -------------------------------------
    
    observeEvent(input$load_geojson, {
      
      # -- Load geojson data
      cat("Loading geojson file... \n")
      
      progressSweetAlert(id = "progress", session = session, value = 10, total = 100, display_pct = TRUE, striped = TRUE, 
                         title = "Chargement du fichier des contours...")
      
      geojson <- geojson_read(file.path(path$resource, input$select_geojson), what = "sp")
      
      updateProgressBar(session, "progress", value = 100, total = 100, title = "Chargement terminé")
      closeSweetAlert(session)
      
      cat("Loading geojson file done! \n")
      
      # ******************* Hack for circo...
      
      if(dim(geojson@data)[1] == 566){
        
        geojson@data$codgeo <- geojson@data$ID
        geojson@data$libgeo <- paste(geojson@data$nom_dpt, "Circonscription n°", geojson@data$num_circ)
        geojson@data$dep <- geojson@data$code_dpt
          
      }
      # *******************
      
      # store
      r$raw_data_map(geojson)
      
      # store list dept
      list_dep(c("Tous", sort(unique(r$raw_data_map()@data$dep))))
      
      
    })
      

    # -------------------------------------
    # Observe r$proxymap
    # -------------------------------------
    
    # observeEvent(r$proxymap, {
    #   
    #   cat("Proxymap is now available \n")
    #   
    #   # -- Load geojson data
    #   if(!exists("raw_data_map")){
    #     
    #     cat("Loading geojson file... \n")
    #     
    #     progressSweetAlert(id = "progress", session = session, value = 10, total = 100, display_pct = TRUE, striped = TRUE, 
    #                        title = "Chargement du contour des communes...")
    #     
    #     geojson <- geojson_read(file.path(path$resource, "a-com2022.json"), what = "sp")
    #     
    #     updateProgressBar(session, "progress", value = 100, total = 100, title = "Chargement terminé")
    #     closeSweetAlert(session)
    #     
    #     cat("Loading geojson file done! \n")
    #     
    #     if(DEBUG){
    #       raw_data_map <<- geojson
    #     }
    #     
    #     # store
    #     r$raw_data_map(geojson)
    #     
    #   } else {
    #     
    #     r$raw_data_map(raw_data_map)
    #     
    #   }
    #   
    #   # store list dept
    #   list_dep(c("Tous", unique(r$raw_data_map()@data$dep)))
    #   
    #   
    # })
    
    
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
      
      if(!"Tous" %in% input$filter_by_dep){
        
        tmp_map <- r$data_map()
        tmp_map <- tmp_map[tmp_map@data$dep %in% input$filter_by_dep, ]
        
        filtered_map(tmp_map)
      } else {
        
        filtered_map(r$data_map())
        
      }
      
      
      filter_by_name(input$filter_by_name)
      color_mode_max(input$color_mode_max)
      color_mode_min(input$color_mode_min)
      color_opacity(input$select_opacity)
      
    })
    
    
    # -------------------------------------
    # Observe
    # -------------------------------------
    
    observeEvent({filtered_map()
      filter_by_name()
      color_mode_max()
      color_mode_min()
      color_opacity()}, {
                    
      cat("New filtered map is available \n")
      
      progressSweetAlert(id = "progress", session = session, value = 10, total = 100, display_pct = TRUE, striped = TRUE, 
                         title = "Mise à jour de la carte...")
      
      filtered_map <- filtered_map()
      col_name <- filter_by_name()
      
      cat("Update map Polygons... \n ")
      cat("- col_name = ", col_name, "\n")
      

      cat("Building labels \n")
      updateProgressBar(session, "progress", value = 20, total = 100, title = "Création des étiquettes...")

      labels <- sprintf(
        "<strong>%s</strong><br/><br/>%s<br/><br/>%s<br/>%s<br/>%s<br/>%s<br/>%s<br/>%s",
        filtered_map@data$libgeo, 
        paste(col_name, ":",
              filtered_map@data[, (colnames(filtered_map@data) %in% col_name)], "voix,",
              round(filtered_map@data[, (colnames(filtered_map@data) %in% col_name)] / filtered_map@data$Exprimés * 100, digits = 2), "%"),
        paste("Inscrits :", filtered_map@data$Inscrits),
        paste("Abstentions :", filtered_map@data$Abstentions, "(", round(filtered_map@data$Abstentions / filtered_map@data$Inscrits * 100, digits = 2), "% )"),
        paste("Votants :", filtered_map@data$Votants),
        paste("Blancs :", filtered_map@data$Blancs),
        paste("Nuls :", filtered_map@data$Nuls),
        paste("Exprimés :", filtered_map@data$Exprimés)
      ) %>% lapply(htmltools::HTML)
      
      if(DEBUG)
        debug_labels <<- labels
      
      cat("Building color palette \n")
      updateProgressBar(session, "progress", value = 40, total = 100, title = "Création de la palette couleur...")
      
      # set max value to compute color palette
      max <- 100
      if(color_mode_max()){
        cat("Compute % max \n")
        #max <- max(filtered_map@data[col_name], na.rm = TRUE)
        max <- max(filtered_map@data[col_name] / filtered_map@data$Exprimés * 100, na.rm = TRUE)
      }
      
      # set min value to compute color palette
      min <- 0
      if(color_mode_min()){
        cat("Compute % min \n")
        #max <- max(filtered_map@data[col_name], na.rm = TRUE)
        min <- min(filtered_map@data[col_name] / filtered_map@data$Exprimés * 100, na.rm = TRUE)
      }
    
      # build color palette  
      pal <- makePalette(min = min, max = max)

      # update map
      cat("Add / Update polygons \n")
      updateProgressBar(session, "progress", value = 50, total = 100, title = "Affichage des contours...")
      r$proxymap %>%
        clearGroup("cities") %>%
        addPolygons(data = filtered_map, 
                    weight = 1, 
                    color = ~pal(filtered_map[[col_name]] / filtered_map@data$Exprimés * 100),
                    fillColor = ~pal(filtered_map[[col_name]] / filtered_map@data$Exprimés * 100), 
                    fillOpacity = input$select_opacity / 100,
                    group = "cities", 
                    label = labels,
                    labelOptions = labelOptions(style = list(
                                                  "font-size" = "12px")))
      
      updateProgressBar(session, "progress", value = 100, total = 100, title = "Terminé")
      closeSweetAlert(session)
      
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

