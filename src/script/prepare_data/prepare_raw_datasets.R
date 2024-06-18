

#' Prepare raw dataset (both presidentielles & legislatives)
#'
#' @param new_datasets a character vector containing the names of the files to process
#' @param pattern a string presidentielles or legislatives (election type)
#' @param notify a logical, whether progress should be displayed (default = FALSE)
#' @param session a session object, where to display progress
#'
#' @return
#' @export
#'
#' @examples prepare_raw_datasets(c("file_1.csv","file_2.csv"))


prepare_raw_datasets <- function(new_datasets, pattern, notify = FALSE, session = NULL){
  
  # notify user
  if(notify)
    showNotification(
      ui = "New dataset found, data processing will start.",
      duration = 5,
      closeButton = TRUE,
      type = c("message"),
      session = session)
  
  
  # get nb dataset to proceed
  nb_iter <- length(new_datasets)
  
  # Set progress bar
  if(notify)
    progressSweetAlert(id = "progress", session = session, value = 0, total = 100, display_pct = TRUE, striped = TRUE, 
                       title = "Début du traitement...")
  
  # helper
  helper <- function(file){
    
    cat("Processing file :", file, "\n")
    
    # get file index (progress)
    index <- which(new_datasets == file)
    start <- (100 / nb_iter) * (index - 1)
    
    
    # -- update progress
    if(notify)
      updateProgressBar(session = session,
                        id = "progress",
                        value =  start + 10 / nb_iter,
                        title = paste("Fichier", index, "/", nb_iter, "Chargement des données..."))
    
    # -- load file
    dataset <- load_with_ukn_cols(file.path(path$data_raw, file))
    
    # -- Debug
    if(DEBUG)
      DEBUG_RAW_DATASET <<- dataset
    
    # -- update progress
    if(notify)
      updateProgressBar(session = session,
                        id = "progress",
                        value =  start + 30 / nb_iter,
                        title = paste("Fichier", index, "/", nb_iter, "Préparation des données..."))
    
    # -- prepare data (transform single lines with multiple candidates into
    # one line per candidate)
    if(pattern == "Europeennes")
      dataset <- prepare_by_candidates2(data = dataset, 
                                        pattern = "Europeennes", 
                                        cols_before = COL_CLASSES_BEFORE_CANDIDATES_EUROPEENNES_COMMUNE, 
                                        cols_candidate = COL_CLASSES_CANDIDATES_EUROPEENNES)
    else
      dataset <- prepare_by_candidates(dataset, pattern)
    
    
    # check drom code ???
    #dataset <- check_drom_code(dataset)
    
    # -- update progress
    if(notify)
      updateProgressBar(session = session,
                        id = "progress",
                        value =  start + 50 / nb_iter,
                        title = paste("Fichier", index, "/", nb_iter, "Ajout des codes geo..."))
    
    # add codegeo
    dataset <- add_codgeo(dataset)
    
    
    # -- update progress
    if(notify)
      updateProgressBar(session = session,
                        id = "progress",
                        value =  start + 70 / nb_iter,
                        title = paste("Fichier", index, "/", nb_iter, "Sauvegarde (patience)..."))
    
    # save
    save_csv(path = path$data_prepared, file = file, data = dataset)
    
    # -- update progress
    if(notify)
      updateProgressBar(session = session,
                        id = "progress",
                        value =  start + 100 / nb_iter,
                        title = paste("Fichier", index, "/", nb_iter, "Traitement terminé..."))
    
    
    cat("Processing file done.\n")
    
  }
  
  # apply helper
  lapply(new_datasets, function(x) helper(x))
  
  if(notify)
    closeSweetAlert(session)
  
}