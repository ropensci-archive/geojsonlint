tg_compact <- function(l) Filter(Negate(is.null), l)

to_json <- function(x, ...) {
  structure(jsonlite::toJSON(x, ..., digits = 22, auto_unbox = TRUE), 
            class = c('json','geo_json'))
}

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}
