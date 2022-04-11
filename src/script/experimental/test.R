
# 
# data_map <- raw_data_map
# 
# 
# 
# #data_map@data[list_candidates] <- dataset[match(data_map@data$codgeo, dataset$codgeo), start:end]
# 
# cols <- colnames(dataset)
# new_cols <- cols[!cols %in% "codgeo"]
# 
# data_map@data[new_cols] <- dataset[match(data_map@data$codgeo, dataset$codgeo), new_cols]


# list_candidates
# 
# foo <- feat_dataset
# 
# foo[list_candidates] <- foo[list_candidates]/foo$Exprimés*100