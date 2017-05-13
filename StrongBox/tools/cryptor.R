cryptor.cypher = NULL

crytor.get.cypher <- function() {
  if (is.null(cryptor.cypher)) {
    pass <- cryptor.get.key()
    key <- charToRaw(substr(pass, 1, 32))
    IV <- sample(0:255, 16, replace=TRUE)
    cryptor.cypher <- AES(key, mode = config.crypt.mode, IV = IV)
  }
  
  cryptor.cypher
}

cryptor.get.key <- function() {
  key <- digest(config.crypt.pass, algo="sha512")
}

cryptor.encrypt <- function(data) {
  cypher <- crytor.get.cypher()
  rawToChar(cypher$encrypt(charToRaw(data)))
}

cryptor.decrypt <- function(data) {
  cypher <- crytor.get.cypher()
  rawToChar(cypher$decrypt(charToRaw(data)))
}