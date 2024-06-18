

# ------------------------------------------------------------------------------
# Shiny: server logic of the Shiny web application
# ------------------------------------------------------------------------------

# -- Define server logic

shinyServer(
  function(input, output, session){
    
    # --------------------------------------------------------------------------
    # Local run & debug
    # --------------------------------------------------------------------------
    
    # -- detect local run
    is_local <- Sys.getenv('SHINY_PORT') == ""
    cat(">> local run =", is_local, "\n")
    
    # -- set DEBUG
    DEBUG <<- is_local
    
    
    # --------------------------------------------------------------------------
    # Analytics
    # --------------------------------------------------------------------------
    
    # -- analytic server
    log_event(session_id = session$token, event = "main_server_start", timestamp = getTimestamp())
    
    
    # --------------------------------------------------------------------------
    # Communication objects
    # --------------------------------------------------------------------------
    
    # -- declare r communication object
    r <- reactiveValues()
    
    # -- loaded dataset (exposed to check if filters can be displayed)
    r$dataset <- reactiveVal(NULL)
    
    
    # --------------------------------------------------------------------------
    # Launch module servers
    # --------------------------------------------------------------------------
    
    # -- the map
    map_Server(id = "map", r = r, path = path)
    
    # -- polygon
    polygon_Server(id = "polygon", r = r, path = path)
    
    # -- election servers
    presidentielles_Server(id = "presidentielles", r = r, path = path)
    legislatives_Server(id = "legislatives", r = r, path = path)
    europeennes_Server(id = "europeennes", r = r, path = path)
    
    # -- analytics
    analytics_Server(id = "analytics", r = r, path = path)
    
  }
)
