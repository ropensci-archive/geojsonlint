#' Lint GeoJSON using geojsonhint Javascript library
#'
#' @export
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param ... Further args passed on to helper functions.
#'
#' @details Uses the Javascript library \url{https://www.npmjs.com/package/geojsonhint}
#'
#' @examples
#' geojson_hint('{"type": "FooBar"}')
#' geojson_hint('{ "type": "FeatureCollection" }')
#' geojson_hint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}')
#'
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
#' geojson_hint(as.location(file))
#'
#' # A URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_hint(as.location(url))
#'
#' # from json (jsonlite class)
#' x <- jsonlite::minify('{ "type": "FeatureCollection" }')
#' class(x)
#' geojson_hint(x)
geojson_hint <- function(x, ...) {
  UseMethod("geojson_hint")
}

#' @export
geojson_hint.default <- function(x, ...) {
  stop("no geojson_hint method for ", class(x), call. = FALSE)
}

#' @export
geojson_hint.character <- function(x, ...) {
  if ( !jsonlite::validate(x) ) stop("invalid json string")
  lintit(x)
}

#' @export
geojson_hint.location <- function(x, ...){
  res <- switch(attr(x, "type"),
                file = paste0(readLines(x), collapse = ""),
                url = jsonlite::minify(httr::content(httr::GET(x), "text", encoding = "UTF-8")))
  lintit(res)
}

#' @export
geojson_hint.json <- function(x, ...){
  lintit(x)
}

#' @export
geojson_hint.geojson <- function(x, ...){
  lintit(unclass(x))
}

lintit <- function(x) {
  ct$assign("x", jsonlite::minify(x))
  ct$eval("var out = geojsonhint.hint(x);")
  tmp <- as.list(ct$get("out"))
  if (identical(tmp, list())) {
    return("valid")
  } else {
    tmp
  }
}
