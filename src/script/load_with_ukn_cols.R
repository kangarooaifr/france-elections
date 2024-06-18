# 
# 
# load_with_ukn_cols <- function(target_file){
#   
#   dat <- read.csv(target_file, col.names = paste("V",1:250), skip = 1, header = F, fill = T, sep = ";", dec = ",")
#   
#   dat <- dat[colSums(!is.na(dat)) > 0]
#   
# }