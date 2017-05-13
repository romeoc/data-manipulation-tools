library(XML)

# Fetch the Alexa info of a url
get.alexa.data <- function(url) {
  url <- paste("http://data.alexa.com/data?cli=10&url=", url, sep = "")
  data <- xmlParse(url)
  data <- xmlToList(data)
  
  info <- data.frame(popularity = ifelse(is.null(data$SD$POPULARITY["TEXT"]), FALSE, data$SD$POPULARITY["TEXT"]),
            reach = ifelse(is.null(data$SD$REACH["RANK"]), FALSE, data$SD$REACH["RANK"]),
            country.code = ifelse(is.null(data$SD$COUNTRY["CODE"]), FALSE, data$SD$COUNTRY["CODE"]),
            country.rank = ifelse(is.null(data$SD$COUNTRY["RANK"]), FALSE, data$SD$COUNTRY["RANK"]),
            stringsAsFactors = FALSE)
  
  return(info)
}

# Loop through a list of websites and fetch the alexa ranking of each. 
# The result is saved in a CSV file
fetch.alexa.info <- function(data) {
  target.file.name <- "alexa.data.csv"
    
  lapply(data$website, function(store) {
    store.alexa.data <- get.alexa.data(store)
    store.alexa.data$websire <- store
    
    write.table(store.alexa.data, target.file.name, row.names = F, na = "NA",
                append = T, quote = FALSE, sep = ",", col.names = F)
    
    Sys.sleep(1)
  })
  
  TRUE
}

# Entry Point - Read Data from CSV and call fetch.alexa.info on it
alexa.worker.start <- function() {
  data <- read.csv("merchants.csv")
  data <- subset(data, select = c("Account.website"))
  colnames(data) <- c("website")
  fetch.alexa.info(data)
  rm(data)
  
  TRUE
}