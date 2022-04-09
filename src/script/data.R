

# --------------------------------------------------------------------------------
# Shiny module: 
# --------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# UI items section
# -------------------------------------

# -- Where gone checkbox
data_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  wellPanel(
    
    # hide / show checkbox
    #uiOutput(ns("select_candidate"))
    selectizeInput(ns("select_candidate"), label = "Candidat", choices = NULL)
    
  )
  
}


# -------------------------------------
# Server logic
# -------------------------------------

data_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    cat("-- Starting data_Server... \n")
    
    # get namespace
    ns <- session$ns
    
    # declare object
    r$data_by_cand <- reactiveVal(NULL)
    selected_candidate <- reactiveVal(NULL)
    list_candidates <- NULL
    
    
    # load data
    if(!exists("PR17_T2")){
      cat("Loading election data... \n")
      PR17_T2 <- read.csv("./data/PR17_BVot_T1_FE.txt", header = TRUE, sep = ";")
      cat("Loading election data done! \n")
    }
    
    nb_cand <- (dim(PR17_T2)[2] - 21)/7
    cat("Nb detected candidates =", nb_cand, "\n")
    
    # preprocess data to merge cols
    PR17_T2_Merge <- pre_process_data(PR17_T2, nb_cand = nb_cand)
    list_candidates <- unique(PR17_T2_Merge$Nom)
    
    updateSelectizeInput(session, "select_candidate", choices = list_candidates, server = TRUE)
    
    if(DEBUG){
      PR17_T2_Merge <<- PR17_T2_Merge
    }
    
    # by candidate
    observeEvent(selected_candidate(), {
      
      summary <- summary_by_candidate(PR17_T2_Merge, n_cand = selected_candidate())
      r$data_by_cand(summary)
    
    }, ignoreInit = TRUE)
    
    
    # -------------------------------------
    # Outputs
    # -------------------------------------
    
    # output$select_candidate <- renderUI({
    #   selectInput(ns("select_candidate"), label = "Candidate", choices = list_candidates, selected = NULL, width = NULL)
    #   })
      
    
    
    
    
    
    # -------------------------------------
    # Event observers
    # -------------------------------------
    
    observeEvent(input$select_candidate, {
      
      cat("Selected candidate =", input$select_candidate, "\n")
      selected_candidate(which(list_candidates == input$select_candidate))
      
    }, ignoreInit = TRUE)

    
  })
}

