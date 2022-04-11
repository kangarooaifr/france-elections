

# --------------------------------------------------------------------------------
# Shiny module: Data
# --------------------------------------------------------------------------------

# -- Library


# -------------------------------------
# UI section
# -------------------------------------

# -- Select dataset
select_dataset_UI <- function(id){
  
  # namespace
  ns <- NS(id)
  
  # UI
  wellPanel(
    
    # init input (empty choices)
    selectizeInput(ns("select_dataset"), label = "Dataset", choices = NULL),
    actionButton(ns("load_dataset"), label = "Load")
    
  )
  
}
