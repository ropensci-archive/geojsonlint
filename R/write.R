#' Write inputs to a geojson file
#'
#' @export
#' @param x input character, json, or geojson
#' @param file file path to write to
#' @param ... Further args
#' @examples
#' gj_write(x = '{"type": "Point", "coordinates": [-100, 80]}',
#'   (file <- tempfile()))
#' jsonlite::fromJSON(file)
gj_write <- function(x, file, ...) {
  UseMethod("gj_write")
}

#' @export
gj_write.default <- function(x, file, ...) {
  stop("no gi_write method for ", class(x), call. = FALSE)
}

#' @export
gj_write.json <- function(x, file, ...) {
  gi_writer(unclass(x), file)
}

#' @export
gj_write.geojson <- function(x, file, ...) {
  gi_writer(unclass(x), file)
}

#' @export
gj_write.character <- function(x, file, ...) {
  gi_writer(x, file)
}

gi_writer <- function(x, file) {
  cat(jsonlite::toJSON(jsonlite::fromJSON(x), pretty = TRUE,
    auto_unbox = TRUE), file = file)
  return(file)
}
