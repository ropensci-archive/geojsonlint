close_conns <- function() {
  cons <- showConnections()
  ours <- as.integer(rownames(cons)[grepl("/geojsonlint|\\.geojson",
    cons[, "description"])])
  for (i in ours) {
    close(getConnection(i))
  }
}

c_get <- function(url, args = list(), ...) {
  conn <- crul::HttpClient$new(url, opts = list(...))
  res <- conn$get(query = args)
  res$raise_for_status()
  res
}

c_post <- function(url, body = list(), ...) {
  conn <- crul::HttpClient$new(url, opts = list(...))
  res <- conn$post(body = body)
  res$raise_for_status()
  res
}
