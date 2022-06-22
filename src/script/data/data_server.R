

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
    r$list_candidates <- reactiveVal(NULL)
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
    
    COL_CLASSES_BEFORE_CANDIDATES_TMP <- c("Code.du.département" = "character",
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
    
    COL_CLASSES_CANDIDATES_PRESIDENTIELLE <- c("N.Panneau" = "numeric",
                                               "Sexe" = "character",
                                               "Nom" = "character",
                                               "Prénom" = "character",
                                               "Voix" = "numeric",
                                               "X..Voix.Ins" = "numeric",
                                               "X..Voix.Exp" = "numeric")
    
    COL_CLASSES_CANDIDATES_LEGISLATIVES <- c("N.Panneau" = "numeric",
                                             "Sexe" = "character",
                                             "Nom" = "character",
                                             "Prénom" = "character",
                                             "Nuance" = "character",
                                             "Voix" = "numeric",
                                             "X..Voix.Ins" = "numeric",
                                             "X..Voix.Exp" = "numeric")
    
    # -- add
    COLS_TO_ADD <- c("Code.de.la.circonscription",
                     "Libellé.de.la.circonscription",
                     "Code.du.b.vote")
    
    
    # -- drop
    COLS_TO_DELETE <- c("Etat saisie")
    
    # -- temporary result
    temp_result <- FALSE
    
    
    # -------------------------------------
    # Init: 
    # -------------------------------------
    
    # get list of dataset and update input
    data_list <- list.files(path$data, pattern = "Presidentielles_", full.names = FALSE, recursive = TRUE, include.dirs = FALSE)
    cat("Available datasets :", length(data_list), "\n")
    
    # build data frame (remove ext, split file name into cols)
    data_list <- data.frame(file.name = data_list)
    data_list[c('election', 'annee', 'tour')] <- str_split_fixed(sub('\\.txt$', '', data_list$file.name), '_', 3)
    
    
    # -------------------------------------
    # dataset selection
    # -------------------------------------
    
    # -- define radio buttons
    output$select_dataset <- renderUI(
      wellPanel(
        
        h4("Présidentielles"),

        # year
        radioButtons(inputId = ns("election_year"),
                     label = "Années",
                     choices = unique(data_list$annee),
                     selected = input$election_year,
                     inline = TRUE),
        
        # turn
        radioButtons(inputId = ns("election_turn"),
                     label = "Tour",
                     choices =  unique(data_list$tour),
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
      target_file <- data_list[data_list$annee == input$election_year &
                               data_list$tour == input$election_turn, ]$file.name
      
      
      # -- Check: for tmp results (before being official)
      if(temp_result)
        COL_CLASSES_BEFORE_CANDIDATES <- COL_CLASSES_BEFORE_CANDIDATES_TMP
      
      # -- Candidate cols depends on election type..
      COL_CLASSES_CANDIDATES <- COL_CLASSES_CANDIDATES_PRESIDENTIELLE
      

      # get length cols
      nb_col_before_candidate <- length(COL_CLASSES_BEFORE_CANDIDATES)
      nb_col_candidate <- length(COL_CLASSES_CANDIDATES)
      
      # build target file
      target_file <- file.path(path$data, target_file)
      
      # read first line
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
      dataset <- read.csv(target_file, header = TRUE, sep = ";", dec = ",", colClasses = colClasses, fileEncoding = "latin1")
      
      updateProgressBar(session, "progress", value = 100, total = 100, title = "Chargement terminé")
      closeSweetAlert(session)
      cat("Loading dataset done! \n")
      
      
      # -- Check: for tmp results (before being official)
      if(temp_result){
        
        dataset <- fit_format(dataset, COLS_TO_ADD, COLS_TO_DELETE)
        nb_col_before_candidate <- 21
        nb_cand <- 2
        
      }

      # pre processing (one col per candidate)
      dataset <- pre_processing(dataset, nb_cand = nb_cand, nb_col_before_candidate, nb_col_candidate)
        
     
      # get list of candidates
      list_candidates <- colnames(dataset[(nb_col_before_candidate + 1):dim(dataset)[2]])
      cat("Candidates :", list_candidates, "\n")
      
      # register filter
      r$filter_by_name(list_candidates)
      r$list_candidates(list_candidates)
      
      # store
      r$dataset(dataset)
      
    })
    
    
    # -------------------------------------
    # Event observers: r$raw_data_map()
    # -------------------------------------
    
    observeEvent({r$raw_data_map()
                 r$dataset()}, {
      
      req(!is.null(r$raw_data_map()))
                   
      cat("New dataset available, size", dim(r$dataset()), "\n")
      
      # init
      data_map <- r$raw_data_map()
      dataset <- r$dataset()
      
      
      # ************ Feat Engineering
      dataset <- if(dim(data_map@data)[1] == 566)
        feat_engineering_circo(dataset, COLS_TO_SUM, r$list_candidates())
      else
        feat_engineering(dataset, COLS_TO_SUM, r$list_candidates())
      
      if(DEBUG)
        feat_dataset <<- dataset
      
      # ************ Feat Engineering
      
      
      # add candidates (match by codgeo)
      cat("Matching codgeo with candidate votes... \n")
      
      cols <- colnames(dataset)
      new_cols <- cols[!cols %in% "codgeo"]
      
      data_map@data[new_cols] <- dataset[match(data_map@data$codgeo, dataset$codgeo), new_cols]
      
      # store
      r$data_map(data_map)
      
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    
  })
}

