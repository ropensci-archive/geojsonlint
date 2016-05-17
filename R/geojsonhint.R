#' Validate GeoJSON using geojsonhint Javascript library
#'
#' @export
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param verbose When geojson is invalid, return reason why (\code{TRUE}) or don't 
#' return reason (\code{FALSE}). Default: \code{FALSE}
#' @param ... Further args passed on to helper functions.
#' 
#' @return \code{TRUE} or \code{FALSE}. If \code{verbose=TRUE} an attribute
#' of name \code{errors} is added with error information
#'
#' @details Uses the Javascript library \url{https://www.npmjs.com/package/geojsonhint}
#' via the \pkg{V8} package
#'
#' @examples
#' geojson_hint('{"type": "FooBar"}')
#' geojson_hint('{ "type": "FeatureCollection" }')
#' geojson_hint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}')
#'
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "geojsonlint")
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
#' 
#' # toggle whether reason for validation failure is given back
#' geojson_hint('{ "type": "FeatureCollection" }')
#' geojson_hint('{ "type": "FeatureCollection" }', verbose = TRUE)
geojson_hint <- function(x, verbose = FALSE, ...) {
  UseMethod("geojson_hint")
}

#' @export
geojson_hint.default <- function(x, verbose = FALSE, ...) {
  stop("no geojson_hint method for ", class(x), call. = FALSE)
}

#' @export
geojson_hint.character <- function(x, verbose = FALSE, ...) {
  if ( !jsonlite::validate(x) ) stop("invalid json string")
  lintit(x, verbose)
}

#' @export
geojson_hint.location <- function(x, verbose = FALSE, ...){
  res <- switch(attr(x, "type"),
                file = paste0(readLines(x), collapse = ""),
                url = jsonlite::minify(httr::content(httr::GET(x), "text", encoding = "UTF-8")))
  lintit(res, verbose)
}

#' @export
geojson_hint.json <- function(x, verbose = FALSE, ...){
  lintit(x, verbose)
}

#' @export
geojson_hint.geojson <- function(x, verbose = FALSE, ...){
  lintit(unclass(x), verbose)
}

# helpers -----------------------------------
lintit <- function(x, verbose) {
  ct$assign("x", jsonlite::minify(x))
  ct$eval("var out = geojsonhint.hint(x);")
  tmp <- as.list(ct$get("out"))
  if (identical(tmp, list())) {
    return(TRUE)
  } else {
    if (verbose) {
      res <- FALSE
      attr(res, "errors") <- data.frame(rev(tmp), stringsAsFactors = FALSE)
      return(res)
    } else {
      return(FALSE)
    }
  }
}
