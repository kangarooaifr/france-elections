

# --------------------------------------------------------------------------------
# Shiny module: Data
# --------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# Server logic
# -------------------------------------

data_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    cat("-- [data] Starting module server... \n")
    
    # get namespace
    ns <- session$ns
    
    # declare communication objects
    r$dataset <- reactiveVal(NULL)
    
    # candidates
    list_candidates <- NULL
    nb_cand <- NULL
    selected_candidate <- reactiveVal(NULL)
    
    nb_col_before_candidate <- NULL
    nb_col_candidate <- NULL
    
    # constants
    COLS_TO_SUM <- c("Inscrits", "Abstentions", "Votants", "Blancs", "Nuls", "Exprimés")
    
    
    COL_CLASSES_BEFORE_CANDIDATES <- c("Code.du.département" = "character",
                                       "Libellé.du.département" = "character",
                                       "Code.de.la.circonscription" = "character",
                                       "Libellé.de.la.circonscription" = "character",
                                       "Code.de.la.commune" = "character",
                                       "Libellé.de.la.commune" = "character",
                                       "Code.du.b.vote" = "character",
                                       "Inscrits" = "numeric",
                                       "Abstentions" = "numeric",
                                       "X..Abs.Ins" = "numeric",
                                       "Votants" = "numeric",
                                       "X..Vot.Ins" = "numeric",
                                       "Blancs" = "numeric",
                                       "X..Blancs.Ins" = "numeric",
                                       "X..Blancs.Vot" = "numeric",
                                       "Nuls" = "numeric",
                                       "X..Nuls.Ins" = "numeric",
                                       "X..Nuls.Vot" = "numeric",
                                       "Exprimés" = "numeric",
                                       "X..Exp.Ins" = "numeric",      
                                       "X..Exp.Vot" = "numeric")
    
    COL_CLASSES_BEFORE_CANDIDATES_2022 <- c("Code.du.département" = "character",
                                       "Libellé.du.département" = "character",
                                       "Code.de.la.commune" = "character",
                                       "Libellé.de.la.commune" = "character",
                                       "Etat saisie" = "character",
                                       "Inscrits" = "numeric",
                                       "Abstentions" = "numeric",
                                       "X..Abs.Ins" = "numeric",
                                       "Votants" = "numeric",
                                       "X..Vot.Ins" = "numeric",
                                       "Blancs" = "numeric",
                                       "X..Blancs.Ins" = "numeric",
                                       "X..Blancs.Vot" = "numeric",
                                       "Nuls" = "numeric",
                                       "X..Nuls.Ins" = "numeric",
                                       "X..Nuls.Vot" = "numeric",
                                       "Exprimés" = "numeric",
                                       "X..Exp.Ins" = "numeric",      
                                       "X..Exp.Vot" = "numeric")
    
    COL_CLASSES_CANDIDATES <- c("N.Panneau" = "numeric",
                                "Sexe" = "character",
                                "Nom" = "character",
                                "Prénom" = "character",
                                "Voix" = "numeric",
                                "X..Voix.Ins" = "numeric",
                                "X..Voix.Exp" = "numeric")
    
    # -- add
    COLS_TO_ADD <- c("Code.de.la.circonscription",
                     "Libellé.de.la.circonscription",
                     "Code.du.b.vote")
    
    
    # -- drop
    COLS_TO_DELETE <- c("Etat saisie")
    
    
    # -------------------------------------
    # Init: 
    # -------------------------------------
    
    # get list of dataset and update input
    data_list <- list.files(path$data, full.names = FALSE, recursive = TRUE, include.dirs = FALSE)
    cat("Available dataset :", length(data_list), "\n")
    updateSelectizeInput(session, "select_dataset", choices = data_list, server = TRUE)
    
    
    # -------------------------------------
    # Event observers: load_dataset
    # -------------------------------------
    
    observeEvent(input$load_dataset, {
      
      cat("input$select_dataset =", input$select_dataset, "\n")
      
      # -- Check: 2022 file format...
      if(input$select_dataset == "Presidentielle_2022_1er_Tour.txt"){
        
        COL_CLASSES_BEFORE_CANDIDATES <- COL_CLASSES_BEFORE_CANDIDATES_2022
        
      }
      
      # get length cols
      nb_col_before_candidate <- length(COL_CLASSES_BEFORE_CANDIDATES)
      nb_col_candidate <- length(COL_CLASSES_CANDIDATES)
      
      # read first line
      target_file <- file.path(path$data, input$select_dataset)
      #first_line <- read.csv(target_file, nrows = 1, header = TRUE, sep = ";")
      first_line <- read.csv(target_file, nrows = 1, header = TRUE, sep = ";", fileEncoding = "latin1")
      
      # get nb of candidates
      nb_cand <- (dim(first_line)[2] - nb_col_before_candidate) / nb_col_candidate
      cat("Nb detected candidates =", nb_cand, "\n")
      
      # build colClasses
      colClasses <- c(COL_CLASSES_BEFORE_CANDIDATES, rep(COL_CLASSES_CANDIDATES, nb_cand))
      
      # load dataset
      cat("Loading dataset :", target_file, "\n")
      progressSweetAlert(id = "progress", session = session, value = 10, total = 100, display_pct = TRUE, striped = TRUE, 
                         title = "Chargement des résultats...")
      #dataset <- read.csv(target_file, header = TRUE, sep = ";", dec = ",", colClasses = colClasses)
      dataset <- read.csv(target_file, header = TRUE, sep = ";", dec = ",", colClasses = colClasses, fileEncoding = "latin1")
      
      updateProgressBar(session, "progress", value = 100, total = 100, title = "Chargement terminé")
      closeSweetAlert(session)
      cat("Loading dataset done! \n")

      # -- DEBUG
      if(DEBUG){
        raw_dataset <<- dataset
      }
      
      # ***************************************************************************************
      # -- !!!DATA!!! FORMAT 2022 STUFF .............
      
      if(input$select_dataset == "Presidentielle_2022_1er_Tour.txt"){
        
        dataset <- fit_format(dataset, COLS_TO_ADD, COLS_TO_DELETE)
        nb_col_before_candidate <- 21
        
        # -- DEBUG
        if(DEBUG){
          format_dataset <<- dataset
        }
        
      }

      # ***************************************************************************************
      
      # check DROM dept code (outre mer, they sometimes put ZA... instead of 97x)
      dataset <- check_drom_code(dataset)
      
      
      # pre processing (one col per candidate)
      dataset <- pre_processing(dataset, nb_cand = nb_cand, nb_col_before_candidate, nb_col_candidate)
     
      if(DEBUG){
        pre_dataset <<- dataset
      }
      
      # get list of candidates
      list_candidates <- colnames(dataset[(nb_col_before_candidate + 1):dim(dataset)[2]])
      cat("Candidates :", list_candidates, "\n")
      
      # register filter
      r$filter_by_name(list_candidates)
      
      # feature engineering
      dataset <- feat_engineering(dataset, COLS_TO_SUM, list_candidates)
      r$dataset(dataset)

      # DEBUG
      if(DEBUG){
        feat_dataset <<- dataset
      }
      
    })
    
    
    # -------------------------------------
    # Event observers: r$raw_data_map()
    # -------------------------------------
    
    observeEvent({r$raw_data_map()
                 r$dataset()}, {
      
      cat("New dataset available, size", dim(r$dataset()), "\n")
      
      # init
      data_map <- r$raw_data_map()
      dataset <- r$dataset()
      
      # add candidates (match by codgeo)
      cat("Matching codgeo with candidate votes... \n")
      
      cols <- colnames(dataset)
      new_cols <- cols[!cols %in% "codgeo"]
      
      data_map@data[new_cols] <- dataset[match(data_map@data$codgeo, dataset$codgeo), new_cols]
      
      #data_map@data[list_candidates] <- dataset[match(data_map@data$codgeo, dataset$codgeo), (nb_col_before_candidate+1):dim(dataset)[2]
      
      if(DEBUG){
        data_map <<- data_map
      }
      
      # store
      r$data_map(data_map)
      
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    
    # >> turn raw_data_map and data_map into r$
    # >> fill raw_data_map in cities
    # >> listen to raw_data_map in data and feed with preprocessing result:
    #    output of preprocessing must be candidate result by row / cities in cols
    #    store output in r$data_map
    # >> listen to r$data_map in cities:
    #    from there you can apply candidate / dept filter
    
    
  })
}

