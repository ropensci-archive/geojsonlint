#' Validate GeoJSON using is-my-json-valid Javascript library
#'
#' @export
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param inform (logical) When geojson is invalid, return reason why (`TRUE`)
#' or don't return reason  `FALSE`). Default: `FALSE`
#' @param error (logical) Throw an error on parse failure? If `TRUE`, then
#' function returns `NULL` on success, and `stop` with the
#' error message on error. Default: `FALSE`
#' @param greedy (logical) Continue after the first error? `TRUE` or `FALSE`.
#' Default: `FALSE`
#'
#' @details Sometimes you may get a response that your input GeoJSON is
#' invalid, but get a somewhat unhelpful error message, e.g.,
#' `no (or more than one) schemas match`. See
#' <https://github.com/ropensci/geojsonlint/issues/7#issuecomment-219881961>.
#' We'll hopefully soon get this sorted out so you'll get a meaningful error
#' message. However, this method is faster than the other two methods in
#' this package, so there is that.
#'
#' @return `TRUE` or `FALSE`. If `inform=TRUE` an attribute
#' of name `errors` is added with error information
#'
#' @references <https://www.npmjs.com/package/is-my-json-valid>
#'
#' @examples
#' # From a json character string
#' ## good
#' geojson_validate('{"type": "Point", "coordinates": [-100, 80]}')
#' ## bad
#' geojson_validate(
#'  '{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}')
#'
#' # A file
#' file <- system.file("examples", "zillow_or.geojson",
#'   package = "geojsonlint")
#' geojson_validate(x = as.location(file))
#'
#' # A URL
#' if (interactive()) {
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_validate(as.location(url))
#' }
#'
#' # toggle whether reason for validation failure is given back
#' geojson_validate('{ "type": "FeatureCollection" }')
#' geojson_validate('{ "type": "FeatureCollection" }', inform = TRUE)
#'
#' # toggle whether to stop with error message
#' geojson_validate('{ "type": "FeatureCollection" }')
#' geojson_validate('{ "type": "FeatureCollection" }', inform = TRUE)
#' if (interactive()) {
#' geojson_validate('{ "type": "FeatureCollection" }', error = TRUE)
#' }
geojson_validate <- function(x, inform = FALSE, error = FALSE,
  greedy = FALSE) {
  UseMethod("geojson_validate")
}

#' @export
geojson_validate.default <- function(x, inform = FALSE, error = FALSE,
  greedy = FALSE) {
  stop("no geojson_validate method for ", class(x), call. = FALSE)
}

#' @export
geojson_validate.character <- function(x, inform = FALSE, error = FALSE,
  greedy = FALSE) {
  validate_geojson(json = x, verbose = inform, greedy = greedy,
    error = error)
}

#' @export
geojson_validate.location <- function(x, inform = FALSE, error = FALSE,
  greedy = FALSE) {
  on.exit(close_conns())
  res <- switch(
    attr(x, "type"),
    file = paste0(readLines(x), collapse = ""),
    url = jsonlite::minify(c_get(x)$parse("UTF-8"))
  )
  validate_geojson(json = res, verbose = inform, greedy = greedy,
    error = error)
}

#' @export
geojson_validate.geojson <- function(x, inform = FALSE, error = FALSE,
  greedy = FALSE) {
  validate_geojson(json = unclass(x), verbose = inform, greedy = greedy,
    error = error)
}

#' @export
geojson_validate.json <- function(x, inform = FALSE, error = FALSE,
  greedy = FALSE) {
  validate_geojson(json = x, verbose = inform, greedy = greedy,
    error = error)
}
