db.connection = NULL

db.connect <- function() {
  if (is.null(db.connection)) {
    db.connection <<- dbConnect(MySQL(), 
      user = config.db.user, 
      password = config.db.pass, 
      dbname = config.db.name, 
      host = config.db.host, 
      port = config.db.port)
  }
  
  db.connection
}

db.disconnect <- function() {
  if (!is.null(db.connection)) {
    dbDisconnect(db.connection)
    db.connection <<- NULL
  }
}

db.write <- function(data) {
  data <- cryptor.encrypt(data);
  dbWriteTable(db.connection, value = data, name = "entity", append = TRUE)
}