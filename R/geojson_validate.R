#' geojson_validate
#'
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param verbose TRUE or FALSE
#' @param greedy TRUE or FALSE
#' @param error TRUE or FALSE
#' 
#' @importFrom jsonvalidate json_validator
#'
#' @return TRUE or FALSE
#' @export
#'
geojson_validate <- function(x, verbose = FALSE, greedy = FALSE, error = FALSE) {
  UseMethod("geojson_validate")
}

#' @export
geojson_validate.default <- function(x, verbose = FALSE, greedy = FALSE, error = FALSE) {
  stop("no geojson_validate method for ", class(x), call. = FALSE)
}

#' @export
geojson_validate.character <- function(x, verbose = FALSE, greedy = FALSE, error = FALSE) {
  validate_geojson(json = x, verbose = verbose, greedy = greedy, error = error)
}

#' @export
geojson_validate.location <- function(x, verbose = FALSE, greedy = FALSE, error = FALSE){
  res <- switch(attr(x, "type"),
                file = paste0(readLines(x), collapse = ""),
                url = jsonlite::minify(httr::content(httr::GET(x), "text", encoding = "UTF-8")))
  validate_geojson(json = res, verbose = verbose, greedy = greedy, error = error)
}

#' @export
geojson_validate.geojson <- function(x, verbose = FALSE, greedy = FALSE, error = FALSE){
  validate_geojson(json = unclass(x), verbose = verbose, greedy = greedy, error = error)
}

#' @export
geojson_validate.json <- function(x, verbose = FALSE, greedy = FALSE, error = FALSE) {
  validate_geojson(json = x, verbose = verbose, greedy = greedy, error = error)
}

# validate_geojson <- jsonvalidate::json_validator(system.file("schema/geojson.json", package = "geojsonlint"))
