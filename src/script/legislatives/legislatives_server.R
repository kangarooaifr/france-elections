

# --------------------------------------------------------------------------------
# Shiny module: Legislatives
# --------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# Server logic
# -------------------------------------

legislatives_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------
    # Config
    # -------------------------------------
    
    cat("-- [Legislatives] Starting module server... \n")
    
    # get namespace
    ns <- session$ns
    
    # config
    module <- paste0("[", id, "]")
    pattern <- "Legislatives"
    
    # -------------------------------------
    # communication objects
    # -------------------------------------
    
    # loaded dataset (exposed to check if filters can be displayed)
    r$dataset <- reactiveVal(NULL)
    
    # observers: feed this to call for apply filters
    r$leg_apply_filters <- reactiveVal(NULL)
    
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    # -- check for new dataset
    new_datasets <- check_new_files(pattern = pattern)
    
    if(!is.null(new_datasets))
      leg_prepare_raw_datasets(new_datasets, session)
    
    
    # -- get available datasets
    available_datasets <- get_available_datasets(pattern = pattern)
    
    
    # -------------------------------------
    # Output
    # -------------------------------------
    
    # -- define radio buttons
    output$select_dataset <- renderUI(
      wellPanel(

        # year
        radioButtons(inputId = ns("election_year"),
                     label = "Années",
                     choices = unique(available_datasets$annee),
                     selected = input$election_year,
                     inline = TRUE),
        
        # turn
        radioButtons(inputId = ns("election_turn"),
                     label = "Tour",
                     choices =  unique(available_datasets$tour),
                     selected = input$election_turn,
                     inline = TRUE),
        
        # load
        actionButton(ns("load_dataset"), label = "Charger")
        
        ))
    
      
    # -------------------------------------
    # Event observers: load_dataset
    # -------------------------------------
    
    observeEvent(input$load_dataset, {
      
      cat("Load dataset \n")
      cat("- election_year =", input$election_year, "\n")
      cat("- election_turn =", input$election_turn, "\n")
      
      # get target file based on inputs
      target_file <- available_datasets[available_datasets$annee == input$election_year & 
                                        available_datasets$tour == input$election_turn, ]$file.name

      # build target file
      target_file <- file.path(path$data_prepared, target_file)
      cat("Target_file :", target_file, "\n")
      
      # monitoring
      start <- getTimestamp()
      
      # read file
      #dataset <- read.csv(target_file, header = TRUE, sep = ";", dec = ",", colClasses = colClasses, fileEncoding = "latin1")
      withProgress(message = 'Chargement...', value = 0.25, {
        dataset <- read.csv(target_file, header = TRUE, sep = ";", dec = ",", fileEncoding = "UTF-8", encoding = "Latin1")})
      
      # monitoring
      end <- getTimestamp()
      
      # notify user
      showNotification(ui = paste("Résultats chargés. (", (end - start) / 1000, "s)"),
                       duration = 5,
                       closeButton = TRUE,
                       type = c("default"),
                       session = session)
      
      
      
      # register filters
      r$filter_by_name(sort(unique(dataset$Nuance)))
      r$filter_by_name_label("Nuance politique")
      r$election_type("leg")
      
      # debug
      if(DEBUG)
        DEBUG_leg_dataset <<- dataset
      
      # store
      r$dataset(dataset)
      
    })
    
    
    # -------------------------------------
    # Event observers: apply filters
    # -------------------------------------
    
    observeEvent(r$leg_apply_filters(), {
      
      # log
      cat(module, "Call to apply filters \n")
      
      # apply
      subset <- leg_apply_filters(x = r$dataset(), filter = r$leg_apply_filters(), module = module)
      
      # check size and store
      cat(module, "Check output size =", dim(subset), "\n")
      if(dim(subset)[1] == 0)
        showNotification(ui = "Résultat vide, veuillez modifier les filtres.",
                         type = "error",
                         session = session)
      else
        r$filtered_dataset(subset)
      
    })
    
    
    
    # observeEvent({r$raw_data_map()
    #              r$dataset()}, {
    #   
    #   req(!is.null(r$raw_data_map()))
    #                
    #   cat("New dataset available, size", dim(r$dataset()), "\n")
    #   
    #   # init
    #   data_map <- r$raw_data_map()
    #   dataset <- r$dataset()
    #   
    #   
    #   # ************ Feat Engineering
    #   dataset <- if(dim(data_map@data)[1] == 566)
    #     feat_engineering_circo(dataset, COLS_TO_SUM, r$list_candidates())
    #   else
    #     feat_engineering(dataset, COLS_TO_SUM, r$list_candidates())
    #   
    #   if(DEBUG)
    #     feat_dataset <<- dataset
    #   
    #   # ************ Feat Engineering
    #   
    #   
    #   # add candidates (match by codgeo)
    #   cat("Matching codgeo with candidate votes... \n")
    #   
    #   cols <- colnames(dataset)
    #   new_cols <- cols[!cols %in% "codgeo"]
    #   
    #   data_map@data[new_cols] <- dataset[match(data_map@data$codgeo, dataset$codgeo), new_cols]
    #   
    #   # store
    #   r$data_map(data_map)
    #   
    # }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    
  })
}

