dfNa <- data.frame(column = rep(NA, 37), naCount = rep(NA, 37))
count <- 1

for (i in names(df)) {
  dfNa[count, 'column'] <- i
  dfNa[count, 'naCount'] <- sum(is.na(df[,i]))
  count <- count + 1
}

dfNa