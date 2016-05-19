close_conns <- function() {
  cons <- showConnections()
  ours <- as.integer(rownames(cons)[grepl("/geojsonlint|\\.geojson", cons[, "description"])])
  for (i in ours) {
    close(getConnection(i))
  }
}
