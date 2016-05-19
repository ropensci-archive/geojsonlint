#' Validate GeoJSON using is-my-json-valid Javascript library
#' 
#' @export
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param verbose (logical) When geojson is invalid, return reason why (\code{TRUE}) or don't
#' return reason (\code{FALSE}). Default: \code{FALSE}
#' @param error (logical) Throw an error on parse failure? If \code{TRUE}, then 
#' function returns \code{NULL} on success, and \code{stop} with the 
#' error message on error. Default: \code{FALSE}
#' @param greedy (logical) Continue after the first error? \code{TRUE} or \code{FALSE}.
#' Default: \code{FALSE}
#'
#' @importFrom jsonvalidate json_validator
#' 
#' @details Sometimes you may get a response that your input GeoJSON is invalid, but 
#' get a somewhat unhelpful error message, e.g., \code{no (or more than one) schemas match}
#' See \url{https://github.com/ropenscilabs/geojsonlint/issues/7#issuecomment-219881961}. 
#' We'll hopefully soon get this sorted out so you'll get a meaningful error message. 
#' However, this method is faster than the other two methods in this package, so 
#' there is that.
#'
#' @return \code{TRUE} or \code{FALSE}. If \code{verbose=TRUE} an attribute
#' of name \code{errors} is added with error information
#' 
#' @references \url{https://www.npmjs.com/package/is-my-json-valid}
#'
#' @examples
#' # From a json character string
#' geojson_validate(x = '{"type": "Point", "coordinates": [-100, 80]}') # good
#' geojson_validate(x = '{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}') # bad
#'
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "geojsonlint")
#' geojson_validate(x = as.location(file))
#'
#' # A URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_validate(as.location(url))
#'
#' # toggle whether reason for validation failure is given back
#' geojson_validate('{ "type": "FeatureCollection" }')
#' geojson_validate('{ "type": "FeatureCollection" }', verbose = TRUE)
#' 
#' # toggle whether to stop with error message
#' geojson_validate('{ "type": "FeatureCollection" }')
#' geojson_validate('{ "type": "FeatureCollection" }', verbose = TRUE)
#' if (interactive()) {
#'   geojson_validate('{ "type": "FeatureCollection" }', error = TRUE)
#' }
geojson_validate <- function(x, verbose = FALSE, error = FALSE, greedy = FALSE) {
  UseMethod("geojson_validate")
}

#' @export
geojson_validate.default <- function(x, verbose = FALSE, error = FALSE, greedy = FALSE) {
  stop("no geojson_validate method for ", class(x), call. = FALSE)
}

#' @export
geojson_validate.character <- function(x, verbose = FALSE, error = FALSE, greedy = FALSE) {
  validate_geojson(json = x, verbose = verbose, greedy = greedy, error = error)
}

#' @export
geojson_validate.location <- function(x, verbose = FALSE, error = FALSE, greedy = FALSE){
  on.exit(close_conns())
  res <- switch(attr(x, "type"),
                file = paste0(readLines(x), collapse = ""),
                url = jsonlite::minify(httr::content(httr::GET(x), "text", encoding = "UTF-8")))
  validate_geojson(json = res, verbose = verbose, greedy = greedy, error = error)
}

#' @export
geojson_validate.geojson <- function(x, verbose = FALSE, error = FALSE, greedy = FALSE){
  validate_geojson(json = unclass(x), verbose = verbose, greedy = greedy, error = error)
}

#' @export
geojson_validate.json <- function(x, verbose = FALSE, error = FALSE, greedy = FALSE) {
  validate_geojson(json = x, verbose = verbose, greedy = greedy, error = error)
}
