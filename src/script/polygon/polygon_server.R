

# --------------------------------------------------------------------------------
# Shiny module: flights
# --------------------------------------------------------------------------------

# -------------------------------------
# Server logic
# -------------------------------------

polygon_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------
    # Config
    # -------------------------------------
    
    # get namespace
    ns <- session$ns
    
    # config
    module <- paste0("[", id, "]")
    
    # -- declare communication objects
    
    # Listen to this to know when geojson data is loaded from file
    r$geojson <- reactiveVal(NULL)
    
    # Feed this with additional @data cols to use for map
    #r$data_map <- reactiveVal(NULL)
    
    # Feed with filtered dataset (to display polygons)
    r$filtered_dataset <- reactiveVal(NULL)
    
    
    # Feed this to apply filters
    r$filter_by_name <- reactiveVal(NULL)
    r$filter_by_name_label <- reactiveVal(NULL)
    r$election_type <- reactiveVal(NULL)
    
    # -- hack to manage european election (since 1 turn but different files)
    r$election_turn <- reactiveVal(NULL)
    
    # to store whether commune / circo are loaded
    geojson_type <- reactiveVal(NULL)
    
    # to store the geojson for display (subset + added @data)
    geojson_to_display <- reactiveVal(NULL)
    
    # to store labels for display
    labels_to_display <- reactiveVal(NULL)
    
    # to store the current filters
    cache_filter_values <- reactiveVal(NULL)
    cache_color_opacity <- reactiveVal(NULL)
    
    # to store color palette function
    cache_color_palette <- reactiveVal(NULL)
    
    #filter_by_dep <- reactiveVal(NULL)
    #filter_by_name <- reactiveVal(NULL)
    #color_mode_max <- reactiveVal(NULL)
    #color_mode_min <- reactiveVal(NULL)
    #color_opacity <- reactiveVal(NULL)
    
    #filtered_map <- reactiveVal(NULL)
    
    # -- declare objects
    #list_dep <- reactiveVal(NULL)
    
    # list available GeoJsons
    list_geojson <- list("Communes" = "a-com2022.json",
                         "Circonscriptions législatives 2012" = "france-circonscriptions-legislatives-2012.json")
    
    # loaded geojson
    is_loaded_geojson <- reactiveVal(rep(FALSE, length(list_geojson)))
    
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    cat("-- [polygons] Starting module server... \n")

    # compute named list of dep for selectInput
    list_choices_dep <- as.character(LISTE_DEP$Code.du.département)
    names(list_choices_dep) <- LISTE_DEP$Libellé.du.département
    
    # add option to select all dep
    list_choices_dep <- append(list("Tous" = "tous"), list_choices_dep)
    
    
    # -------------------------------------
    # Outputs
    # -------------------------------------
    
    
    # geojson (replace next blocs)
    output$geojson <- renderUI({
      
      # -- check if dataset loaded
      if(!is.null(r$dataset())){
        
        if(r$election_type() == "eur"){
          
          if(r$election_turn() == "circonscription")
            choices <- list("Circonscriptions législatives 2012" = "france-circonscriptions-legislatives-2012.json")
          
          else
            choices  <- list("Communes" = "a-com2022.json")
          
        } else
          choices <- list_geojson
        
        wellPanel(
          selectizeInput(ns("select_geojson"), label = "Contours", choices = choices),
          actionButton(ns("load_geojson"), label = "Charger"))
        
      } else
        NULL
      
    })
    
    # # select geojson
    # output$select_geojson <- renderUI(
    #   if(!is.null(r$dataset()))
    #     selectizeInput(ns("select_geojson"), label = "Contours", choices = list_geojson)
    #   else
    #     NULL)
    # 
    # # show hide action button
    # output$action_geojson <- renderUI(actionButton(ns("load_geojson"), label = "Charger"))
    
    # warning - dataset
    output$warning_dataset <- renderUI({
      
      if(is.null(r$dataset()))
        box(title = "Message", width = 12, solidHeader = TRUE, status = "warning",
            "Chargez un résultat d'élection")
    })
    
    # warning - geojson
    output$warning_geojson <- renderUI({
      
      # whether or not a dataset is loaded 
      if(!is.null(r$dataset()))
      
        # whether or not a geojson is loaded 
        if(is.null(r$geojson()))
          box(title = "Message", width = 12, solidHeader = TRUE, status = "warning",
              "Chargez un fichier de contours")
      
    })
    
    
    output$filter_panel <- renderUI({
      
      # if both are loaded
      if(!is.null(r$dataset()) & !is.null(r$geojson())){
        wellPanel(
            
            # init (empty choices)
            selectizeInput(ns("filter_by_name"), label = r$filter_by_name_label(), choices = r$filter_by_name()),
            selectizeInput(ns("filter_by_dep"), label = "Départements", choices = list_choices_dep, multiple = TRUE),
            
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
    
    
    
    output$hide_show <- renderUI(
      
      if(!is.null(r$dataset()) & !is.null(r$geojson()))
        # UI
        wellPanel(
          # input
          checkboxInput(ns("submit_hide_show"), label = "Afficher / Cacher", value = TRUE, width = NULL))
      
    )
    
    
    
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
        geojson <- geojsonio::geojson_read(file.path(path$resource, input$select_geojson), what = "sp")})
      
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
        
        cat(module, "WARNING: Fixing circo geojson !!! \n")
        geojson@data$codgeo <- geojson@data$ID
        geojson@data$libgeo <- paste(geojson@data$nom_dpt, "Circonscription n°", geojson@data$num_circ)
        geojson@data$dep <- geojson@data$code_dpt
          
      }
      # *******************
      
      
      if(DEBUG)
        DEBUG_RAW_GEOJSON <<- geojson
      
      # store geojson & type
      r$geojson(geojson)
      geojson_type(names(list_geojson[list_geojson == input$select_geojson]))
      
      # store list dept
      #list_dep(c("Tous", sort(unique(r$geojson()@data$dep))))
      
    })
    
    
    # -------------------------------------
    # Observe r$data_map()
    # -------------------------------------
    
    # observeEvent(r$data_map(), {
    #   
    #   # setup filters
    #   cat("Update filters with choices \n")
    #   updateSelectizeInput(session, "filter_by_name", label = r$filter_by_name_label(), choices = r$filter_by_name(), server = TRUE)
    # 
    # })

    # update filter by name
    # observeEvent(r$filter_by_name(), {
    #   
    #   # get values
    #   label <- r$filter_by_name_label()
    #   choices <- r$filter_by_name()
    #   
    #   # setup filters
    #   cat(module, "Update filter_by_name (label & choices) \n")
    #   cat("-- label =", label, "\n")
    #   cat("-- choices =", choices, "\n")
    #   updateSelectizeInput(session, "filter_by_name", label = label, choices = choices, server = TRUE)
    #   
    # })
   

    # -------------------------------------
    # Observe filters
    # -------------------------------------
    
    # display perfo warning
    observeEvent(input$filter_by_dep, {
      
      # warning - geojson
      output$warning_perfo <- renderUI({
        
        # whether or not a geojson is loaded 
        if("tous" %in% input$filter_by_dep  & geojson_type() == "Communes")
          box(title = "Message", width = 12, solidHeader = TRUE, status = "warning",
              "Afficher les communes de tous les départements peut être long...")})
      
    })
    
    # submit btn
    observeEvent(input$submit_filters, {

      # check
      req(input$filter_by_dep)

      # get values
      filter_values <- list(name = input$filter_by_name,
                            dep = input$filter_by_dep)
      
      # check if filters have been modified! (to avoid extra computation)
      is_same_filter <- compare_filters(new = filter_values, old = cache_filter_values())
      
      # register filters to observers
      if(!is_same_filter){
        
        cat(module, "New filters submitted : \n")
        cat("-- by dep =", input$filter_by_dep, "\n")
        
        # store new values
        cache_filter_values(filter_values)
        
        # check election type
        if(r$election_type() == "leg")
          
          r$leg_apply_filters(filter_values)
        
        else if(r$election_type() == "eur")
          
          r$eur_apply_filters(filter_values)
        
        else {
          
          r$pdt_apply_filters(filter_values)}}
      
    })
    
    
    # -------------------------------------
    # Observe: filtered dataset
    # -------------------------------------
    
    observeEvent(r$filtered_dataset(), {
      
      cat(module, "New filtered_dataset is available \n")
      
      # -- init values
      geo_type <- geojson_type()
      geojson <- r$geojson()
      data <- r$filtered_dataset()
      election_type <- r$election_type()
      
      # -- aggregate data by geocode
      data <- aggregate_by_codgeo(geo_type, data, election_type = election_type)
      
      # -- subset geojson
      geojson <- subset_geojson(geo_type = geo_type, geojson = geojson, data = data)
      
      # -- feed geojson with filtered data
      geojson <- add_data_to_geojson(geojson = geojson, data = data)
      
      # -- build labels
      labels <- build_labels(geojson = geojson)
      
      # -- store geojson & labels
      geojson_to_display(geojson)
      labels_to_display(labels)
      
    })
    
    
    # -------------------------------------
    # Observer: manage color palette
    # -------------------------------------
    
    # when geojson with data is updated
    observeEvent(geojson_to_display(), {
      
      # get value
      geojson <- geojson_to_display()
      
      # get color palette
      color_pal <- make_color_palette(geojson, input$color_mode_min, input$color_mode_max)
      
      # cache values
      cache_color_palette(color_pal)
      
    })
    
    # when color options are updated
    observeEvent({
      input$color_mode_min
      input$color_mode_max}, {
        
        # make sure geojson is available
        req(geojson_to_display())
        
        # get value
        geojson <- geojson_to_display()
        
        # get color palette
        color_pal <- make_color_palette(geojson, input$color_mode_min, input$color_mode_max)
        
        # cache values
        cache_color_palette(color_pal)
        
      })
    
    
    # -------------------------------------
    # Observer: call for display
    # -------------------------------------
    
    observeEvent({
      geojson_to_display()
      cache_color_palette()
      input$select_opacity}, {
        
        # required!
        req(geojson_to_display(), cache_color_palette(), input$select_opacity)
        
        cat(module, "Updating polygons on map \n")
        
        # -- init values
        geojson <- geojson_to_display()
        labels <- labels_to_display()
        color_pal <- cache_color_palette()
        
        # -- update display on map
        r$proxymap %>%
          clearGroup("polygons") %>%
          addPolygons(data = geojson, 
                      weight = 1, 
                      color = color_pal(geojson@data$Voix / geojson@data$Exprimés * 100),
                      fillColor = color_pal(geojson@data$Voix / geojson@data$Exprimés * 100), 
                      fillOpacity = input$select_opacity / 100,
                      group = "polygons", 
                      label = labels,
                      labelOptions = labelOptions(style = list(
                        "font-size" = "12px")))
        
      }, ignoreInit = TRUE)
    
    
    # -------------------------------------
    # Observe
    # -------------------------------------
    
    # observeEvent({filtered_map()
    #   filter_by_name()
    #   color_mode_max()
    #   color_mode_min()
    #   color_opacity()}, {
    #                 
    #   cat("New filtered map is available \n")
    #   
    #   progressSweetAlert(id = "progress", session = session, value = 10, total = 100, display_pct = TRUE, striped = TRUE, 
    #                      title = "Mise à jour de la carte...")
    #   
    #   filtered_map <- filtered_map()
    #   col_name <- filter_by_name()
    #   
    #   cat("Update map Polygons... \n ")
    #   cat("- col_name = ", col_name, "\n")
    #   
    # 
    #   cat("Building labels \n")
    #   updateProgressBar(session, "progress", value = 20, total = 100, title = "Création des étiquettes...")
    # 
    #   labels <- sprintf(
    #     "<strong>%s</strong><br/><br/>%s<br/><br/>%s<br/>%s<br/>%s<br/>%s<br/>%s<br/>%s",
    #     filtered_map@data$libgeo, 
    #     paste(col_name, ":",
    #           filtered_map@data[, (colnames(filtered_map@data) %in% col_name)], "voix,",
    #           round(filtered_map@data[, (colnames(filtered_map@data) %in% col_name)] / filtered_map@data$Exprimés * 100, digits = 2), "%"),
    #     paste("Inscrits :", filtered_map@data$Inscrits),
    #     paste("Abstentions :", filtered_map@data$Abstentions, "(", round(filtered_map@data$Abstentions / filtered_map@data$Inscrits * 100, digits = 2), "% )"),
    #     paste("Votants :", filtered_map@data$Votants),
    #     paste("Blancs :", filtered_map@data$Blancs),
    #     paste("Nuls :", filtered_map@data$Nuls),
    #     paste("Exprimés :", filtered_map@data$Exprimés)
    #   ) %>% lapply(htmltools::HTML)
    #   
    #   if(DEBUG)
    #     debug_labels <<- labels
    #   
    #   cat("Building color palette \n")
    #   updateProgressBar(session, "progress", value = 40, total = 100, title = "Création de la palette couleur...")
    #   
    #   # set max value to compute color palette
    #   max <- 100
    #   if(color_mode_max()){
    #     cat("Compute % max \n")
    #     #max <- max(filtered_map@data[col_name], na.rm = TRUE)
    #     max <- max(filtered_map@data[col_name] / filtered_map@data$Exprimés * 100, na.rm = TRUE)
    #   }
    #   
    #   # set min value to compute color palette
    #   min <- 0
    #   if(color_mode_min()){
    #     cat("Compute % min \n")
    #     #max <- max(filtered_map@data[col_name], na.rm = TRUE)
    #     min <- min(filtered_map@data[col_name] / filtered_map@data$Exprimés * 100, na.rm = TRUE)
    #   }
    # 
    #   # build color palette  
    #   pal <- makePalette(min = min, max = max)
    # 
    #   # update map
    #   cat("Add / Update polygons \n")
    #   updateProgressBar(session, "progress", value = 50, total = 100, title = "Affichage des contours...")
    #   r$proxymap %>%
    #     clearGroup("polygons") %>%
    #     addPolygons(data = filtered_map, 
    #                 weight = 1, 
    #                 color = ~pal(filtered_map[[col_name]] / filtered_map@data$Exprimés * 100),
    #                 fillColor = ~pal(filtered_map[[col_name]] / filtered_map@data$Exprimés * 100), 
    #                 fillOpacity = input$select_opacity / 100,
    #                 group = "polygons", 
    #                 label = labels,
    #                 labelOptions = labelOptions(style = list(
    #                                               "font-size" = "12px")))
    #   
    #   updateProgressBar(session, "progress", value = 100, total = 100, title = "Terminé")
    #   closeSweetAlert(session)
    #   
    # })

    
    # -------------------------------------
    # Observe hide / show
    # -------------------------------------
    
    observeEvent(input$submit_hide_show, {

      # checkbox marked
      if(input$submit_hide_show){

        cat("Show group: polygons \n")

        # proxy map
        r$proxymap %>%

          # Show group
          showGroup('polygons')

      }else{

        cat("Hide group: polygons \n")

        # proxy map
        r$proxymap %>%

          # clear group
          hideGroup('polygons')
      }

    }, ignoreInit = TRUE)
    
  })
}

