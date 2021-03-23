df <- data.frame(key=rep(c(1,2,3), 3), value=sample(1:10, 9, replace=T)) 


# cumsum

library(data.table)
DT <- data.table(df, key = "key")
DT[, csum := cumsum(value), by = key(DT)]