

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
    
    cat("-- [analytics] Starting module server... \n")
    
    # get namespace
    ns <- session$ns
    
    r$analytics <- reactiveVal(NULL)
  
    
    # -------------------------------------
    # Init
    # -------------------------------------
    
    
    cat("session token =", session$token)

    
    # -------------------------------------
    # Output
    # -------------------------------------
    
    

    
      
    # -------------------------------------
    # Event observers: load_dataset
    # -------------------------------------
    
    observeEvent(r$analytics(), {
      
      event <- data.frame(session_id = session$token,
                          timestamp = getTimestamp(),
                          event_type = "log")

      
      
      
      
    })

    
  })
}

