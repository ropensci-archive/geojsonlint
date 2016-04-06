#' geojson_validate
#'
#' @param json the json object
#' @param verbose TRUE or FALSE
#' @param greedy TRUE or FALSE
#' @param error TRUE or FALSE
#' 
#' @importFrom jsonvalidate json_validator
#'
#' @return TRUE or FALSE
#' @export
#'
geojson_validate <- function(json, verbose = FALSE, greedy = FALSE, error = FALSE) {
  UseMethod("geojson_validate")
}

#' @export
geojson_validate.json <- function(json, verbose = FALSE, greedy = FALSE, error = FALSE) {
  validate_geojson(json = json, verbose = verbose, greedy = greedy, error = error)
}

validate_geojson <- jsonvalidate::json_validator(system.file("schema/geojson.json", package = "geojsonlint"))
