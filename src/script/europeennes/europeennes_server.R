

# --------------------------------------------------------------------------------
# Shiny module: Data
# --------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# Server logic
# -------------------------------------

europeennes_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------
    # Config
    # -------------------------------------
    
    # get namespace
    ns <- session$ns
    
    # config
    module <- paste0("[", id, "]")
    pattern <- "Europeennes"
    
    
    # -------------------------------------
    # communication objects
    # -------------------------------------

    # observers: feed this to call for apply filters
    r$eur_apply_filters <- reactiveVal(NULL)
    
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    cat(module, "-- Starting module server... \n")
    
    # -- check for new dataset
    #new_datasets <- check_new_files(pattern = pattern)
    
    # if(!is.null(new_datasets))
    #   prepare_raw_datasets(new_datasets = new_datasets, pattern = pattern, notify = TRUE, session = session)
    # 
    
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

      cat(module, "load_dataset btn hit \n")
      
      # get target file based on inputs
      target_file <- available_datasets[available_datasets$annee == input$election_year &
                                          available_datasets$tour == input$election_turn, ]$file.name

      # load
      dataset <- load_prepared_data(target_file = target_file, colClasses = COL_CLASSES_PREPARED_EUROPEENNES, session = session)
      
      # register filters
      r$filter_by_name(paste(unique(dataset$Nom), unique(dataset$Prénom)))
      r$filter_by_name_label("Candidat(e)s")
      r$election_type("eur")
      r$election_turn(input$election_turn)

      # store
      r$dataset(dataset)

    })

    
    # -------------------------------------
    # Event observers: apply filters
    # -------------------------------------
    
    observeEvent(r$eur_apply_filters(), {

      # log
      cat(module, "Call to apply filters \n")

      # apply
      subset <- eur_apply_filters(x = r$dataset(), filter = r$eur_apply_filters(), module = module)
      
      # check size and store
      cat(module, "Check output size =", dim(subset), "\n")
      if(dim(subset)[1] == 0)
         showNotification(ui = "Résultat vide, veuillez modifier les filtres.",
                          type = "error",
                          session = session)
       else
         r$filtered_dataset(subset)

    })
    

  })
}

