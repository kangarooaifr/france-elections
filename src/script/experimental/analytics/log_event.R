

#' Append event to log
#'
#' @param session_id the id of the session
#' @param event a string (the event token)
#' @param timestamp the timestamp
#'
#' @return
#' @export
#'
#' @examples

log_event <- function(session_id, event, timestamp){
  
  # build url
  url <- file.path(path$analytics, "events.csv")

  # create event
  row <- data.frame(session_id = session_id,
                      event = event,
                      timestamp = timestamp)
  
  # write
  write.table(row, file = url, append = TRUE, quote = FALSE, sep = ",", row.names = FALSE, col.names = FALSE)
  
}
