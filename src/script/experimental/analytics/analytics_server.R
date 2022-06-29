

# --------------------------------------------------------------------------------
# Shiny module: analytics
# --------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# Server logic
# -------------------------------------

analytics_Server <- function(id, r, path) {
  moduleServer(id, function(input, output, session) {
    
    # -------------------------------------
    # Config
    # -------------------------------------
    
    # get namespace
    ns <- session$ns
    
    module <- paste0("[", id, "]")
    
    
    # -------------------------------------
    # Communication objects
    # -------------------------------------
    
    r$analytics <- reactiveVal(NULL)
  
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    cat(module, "-- Starting module server... \n")
    
    
    # -------------------------------------
    # Output
    # -------------------------------------
    
    
    # expected_time <- get_expected_time(event = "load", url = "xxx")
    # 
    # 
    # 
    
    # -------------------------------------
    # Event observers: load_dataset
    # -------------------------------------
    
    # observeEvent(r$analytics(), {
    #   
    #   event <- data.frame(session_id = session$token,
    #                       timestamp = getTimestamp(),
    #                       event_type = "log")
    # 
    #   
    #   
    #   
    #   
    # })

    
  })
}

