


log_time <- function(session_id, event, start, end, time = NULL){
  
  # build url
  url <- file.path(path$analytics, "time.csv")
  
  # check
  if(is.null(time))
    time <- end - start
  
  # create event
  row <- data.frame(session_id = session_id,
                      event = event,
                      start = start,
                      end = end,
                      time = time)
  
  # write
  write.table(row, file = url, append = TRUE, quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE)
  
  
}