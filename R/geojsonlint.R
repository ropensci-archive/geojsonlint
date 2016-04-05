#' Validate GeoJSON using geojson_lint.com
#'
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param ... curl options passed on to \code{\link[httr]{GET}} or
#' \code{\link[httr]{POST}}
#'
#' @details Uses the web service at \url{http://geojsonlint.com}
#'
#' @examples \dontrun{
#' # From a json character string
#' geojson_lint(x = '{"type": "Point", "coordinates": [-100, 80]}') # good
#' geojson_lint(x = '{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}') # bad
#'
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
#' geojson_lint(x = as.location(file))
#'
#' # A URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_lint(as.location(url))
#' }

#' @export
geojson_lint <- function(x, ...) {
  UseMethod("geojson_lint")
}

#' @export
geojson_lint.default <- function(x, ...){
  stop("no geojson_lint method for ", class(x), call. = FALSE)
}

#' @export
geojson_lint.character <- function(x, ...){
  if (!jsonlite::validate(x)) stop("invalid json string", call. = FALSE)
  res <- httr::POST(geojsonlint_url(), body = x, ...)
  httr::stop_for_status(res)
  jsonlite::fromJSON(httr::content(res, "text", encoding = "UTF-8"))
}

#' @export
geojson_lint.location <- function(x, ...){
  res <- switch(attr(x, "type"),
                file = httr::POST(geojsonlint_url(), body = httr::upload_file(x[[1]]), ...),
                url = httr::GET(geojsonlint_url(), query = list(url = x[[1]]), ...))
  httr::stop_for_status(res)
  jsonlite::fromJSON(httr::content(res, "text", encoding = "UTF-8"))
}

#' @export
geojson_lint.json <- function(x, ...){
  val_fxn(x, ...)
}

#' @export
geojson_lint.geojson <- function(x, ...){
  val_fxn(unclass(x), ...)
}

val_fxn <- function(x, ...){
  file <- tempfile(fileext = ".geojson")
  suppressMessages(gj_write(x, file = file))
  res <- httr::POST(geojsonlint_url(), body = httr::upload_file(file), ...)
  httr::stop_for_status(res)
  jsonlite::fromJSON(httr::content(res, "text", encoding = "UTF-8"))
}

geojsonlint_url <- function() 'http://geojsonlint.com/validate'
