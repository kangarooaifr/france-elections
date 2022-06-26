

# --------------------------------------------------------------------------------
# Shiny module: flights
# --------------------------------------------------------------------------------

# -- Library
library(geojsonio)


# -------------------------------------
# Server logic
# -------------------------------------

polygon_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    cat("-- [cities] Starting module server... \n")
    
    # get namespace
    ns <- session$ns
    
    # config
    module <- paste0("[", id, "]")
    
    # -- declare communication objects
    
    # Listen to this to know when geojson data is loaded from file
    r$geojson <- reactiveVal(NULL)
    
    # Feed this with additional @data cols to use for map
    r$data_map <- reactiveVal(NULL)
    
    # Feed with filtered dataset (to display polygons)
    r$filtered_dataset <- reactiveVal(NULL)
    
    
    # Feed this to apply filters
    r$filter_by_name <- reactiveVal(NULL)
    r$filter_by_name_label <- reactiveVal(NULL)
    r$election_type <- reactiveVal(NULL)
    
    # to store whether commune / circo are loaded
    geojson_type <- reactiveVal(NULL)
    
    
    
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
    
    # warning - dataset
    output$warning_dataset <- renderUI({
      
      if(is.null(r$dataset()))
        box(title = "Message", width = 12, solidHeader = TRUE, status = "warning",
            "Chargez un résultat d'élection")
    })
    
    # warning - geojson
    output$warning_geojson <- renderUI({
      
      # whether or not a geojson is loaded 
      if(is.null(r$geojson()))
        box(title = "Message", width = 12, solidHeader = TRUE, status = "danger",
            "Chargez un fichier de contours")
      
    })
    
    
    output$filter_panel <- renderUI({
      
      # if both are loaded
      if(!is.null(r$dataset()) & !is.null(r$geojson())){
        wellPanel(
            
            # init (empty choices)
            selectizeInput(ns("filter_by_name"), label = "Candidat", choices = NULL),
            selectizeInput(ns("filter_by_dep"), label = "Départements", choices = LISTE_DES_DEPARTEMENTS, multiple = TRUE),
            
            # color palette
            checkboxInput(ns("color_mode_min"), label = "Couleurs : activer % min", value = TRUE, width = NULL),
            checkboxInput(ns("color_mode_max"), label = "Couleurs : activer % max", value = TRUE, width = NULL),
            p("Calcul des couleurs en fonction des % du candidat dans la zone sélectionnée (sinon de 0 à 100%)"),
            
            # opacity
            sliderInput(
              inputId = ns("select_opacity"),
              label = "Opacité",
              min = 0,
              max = 100,
              value = 80,
              step = 5),
            
            actionButton(ns("submit_filters"), label = "Afficher"))}
    })
    
    
    # -------------------------------------
    # Observe load_geojson
    # -------------------------------------
    
    observeEvent(input$load_geojson, {
      
      # -- Load geojson data
      cat("Loading geojson file... \n")
      
      # monitoring
      start <- getTimestamp()
      
      # load
      withProgress(message = 'Chargement...', value = 0.25, {
        geojson <- geojson_read(file.path(path$resource, input$select_geojson), what = "sp")})
      
      # monitoring
      end <- getTimestamp()
      
      # notify user
      showNotification(ui = paste("Contours chargés. (", (end - start) / 1000, "s)"),
                       duration = 5,
                       closeButton = TRUE,
                       type = c("default"),
                       session = session)
      
      cat("Loading geojson file done! \n")
      
      # ******************* Hack for circo...
      
      if(dim(geojson@data)[1] == 566){
        
        geojson@data$codgeo <- geojson@data$ID
        geojson@data$libgeo <- paste(geojson@data$nom_dpt, "Circonscription n°", geojson@data$num_circ)
        geojson@data$dep <- geojson@data$code_dpt
          
      }
      # *******************
      
      # store geojson & type
      r$geojson(geojson)
      geojson_type(names(list_geojson[list_geojson == input$select_geojson]))
      
      
      # store list dept
      list_dep(c("Tous", sort(unique(r$geojson()@data$dep))))
      
      
    })
    
    
    # -------------------------------------
    # Observe r$data_map()
    # -------------------------------------
    
    observeEvent(r$data_map(), {
      
      # setup filters
      cat("Update filters with choices \n")
      updateSelectizeInput(session, "filter_by_name", label = r$filter_by_name_label(), choices = r$filter_by_name(), server = TRUE)
    
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


      
      # create event
      event <- list(name = input$filter_by_name,
                    dep = input$filter_by_dep,
                    color_mode_max = input$color_mode_max,
                    color_mode_min = input$color_mode_min,
                    color_opacity = input$select_opacity)
      
      # register event to observers
      if(r$election_type() == "leg")
        
        r$leg_apply_filters(event)
      
      else {
        
        filter_by_name(input$filter_by_name)
        color_mode_max(input$color_mode_max)
        color_mode_min(input$color_mode_min)
        color_opacity(input$select_opacity)}

    })
    
    
    # -------------------------------------
    # Event observers: display polygons
    # -------------------------------------
    
    observeEvent(r$filtered_dataset(), {
      
      cat(module, "New filtered_dataset is available \n")
      
      # init values
      filtered_geojson <- r$geojson()
      geojson_type <- geojson_type()
      
      
      
      # *****************************************************************************************
      #
      # >> il faut remplacer le select input dep pour avoir les noms affichés, mais les valeurs retournées
      # >> je crois qu'il faut lui donner une named liste en choice
      #
      
      DEBUG_GEOJSON <<- r$geojson()
      DEBUG_FILTERED_DATASET <<- r$filtered_dataset()
      
      # >> ensuite vérifier si on peut bien filter ci-dessous
      
      # *****************************************************************************************
      
    
      
      # subset by dep
      if(geojson_type == "Circonscriptions législatives 2012"){
        
        filtered_geojson <- filtered_geojson[filtered_geojson@data$dep %in% input$filter_by_dep, ]
        
      }
      
      
      
      
      
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

