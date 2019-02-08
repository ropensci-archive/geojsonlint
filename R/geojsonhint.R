#' Validate GeoJSON using geojsonhint Javascript library
#'
#' @export
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param inform (logical) When geojson is invalid, return reason why
#' (`TRUE`) or don't return reason (`FALSE`). Default: `FALSE`
#' @param error (logical) Throw an error on parse failure? If `TRUE`, then
#' function returns `TRUE` on success, and \code{stop} with the
#' error message on error. Default: `FALSE`
#'
#' @return `TRUE` or `FALSE`. If `inform=TRUE` an attribute
#' of name `errors` is added with error information
#'
#' @details Uses the Javascript library
#' <https://www.npmjs.com/package/geojsonhint> via the \pkg{V8} package
#'
#' @examples
#' geojson_hint('{"type": "FooBar"}')
#' geojson_hint('{ "type": "FeatureCollection" }')
#' geojson_hint(
#'   '{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}'
#' )
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
#' geojson_hint('{ "type": "FeatureCollection" }', inform = TRUE)
#'
#' # toggle whether to stop with error message
#' geojson_hint('{ "type": "FeatureCollection" }')
#' geojson_hint('{ "type": "FeatureCollection" }', inform = TRUE)
#' if (interactive()) {
#'   geojson_hint('{ "type": "FeatureCollection" }', error = TRUE)
#' }
geojson_hint <- function(x, inform = FALSE, error = FALSE) {
  UseMethod("geojson_hint")
}

#' @export
geojson_hint.default <- function(x, inform = FALSE, error = FALSE) {
  stop("no geojson_hint method for ", class(x), call. = FALSE)
}

#' @export
geojson_hint.character <- function(x, inform = FALSE, error = FALSE) {
  if ( !jsonlite::validate(x) ) stop("invalid json string", call. = FALSE)
  lintit(x, inform, error)
}

#' @export
geojson_hint.location <- function(x, inform = FALSE, error = FALSE) {
  res <- switch(
    attr(x, "type"),
    file = paste0(readLines(x), collapse = ""),
    url = jsonlite::minify(c_get(x)$parse("UTF-8"))
  )
  lintit(res, inform, error)
}

#' @export
geojson_hint.json <- function(x, inform = FALSE, error = FALSE) {
  lintit(x, inform, error)
}

#' @export
geojson_hint.geojson <- function(x, inform = FALSE, error = FALSE) {
  lintit(unclass(x), inform, error)
}

# helpers -----------------------------------
lintit <- function(x, inform, error) {
  ct$assign("x", jsonlite::minify(x))
  ct$eval("var out = geojsonhint.hint(x);")
  tmp <- as.list(ct$get("out"))
  if (error && !identical(tmp, list())) {
    stop("Line ", tmp$line, "\n       - ", tmp$message, call. = FALSE)
  } else {
    if (identical(tmp, list())) {
      return(TRUE)
    } else {
      if (inform) {
        res <- FALSE
        attr(res, "errors") <- data.frame(rev(tmp), stringsAsFactors = FALSE)
        return(res)
      } else {
        return(FALSE)
      }
    }
  }
}
