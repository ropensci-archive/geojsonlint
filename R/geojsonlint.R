#' Validate GeoJSON using geojsonlint.com web service
#'
#' @export
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param inform (logical) When geojson is invalid, return reason why
#' (`TRUE`) or don't return reason (`FALSE`). Default: `FALSE`
#' @param error (logical) Throw an error on parse failure? If `TRUE`, then
#' function returns `TRUE` on success, and \code{stop} with the
#' error message on error. Default: `FALSE`
#' @param ... curl options passed on to [crul::verb-GET] or
#' [crul::verb-POST]
#'
#' @details Uses the web service at <http://geojsonlint.com>
#'
#' @return `TRUE` or `FALSE`. If `inform=TRUE` an attribute
#' of name \code{errors} is added with error information
#'
#' @examples \dontrun{
#' library(jsonlite)
#' 
#' # From a json character string
#' ## good
#' geojson_lint('{"type": "Point", "coordinates": [-100, 80]}')
#' json_good <- minify('{"type": "Point", "coordinates": [-100, 80]}')
#' geojson_lint(json_good)
#' ## bad
#' geojson_lint('{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}')
#' json_bad <- minify(
#'  '{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}')
#' geojson_lint(json_bad)
#'
#' # A file
#' file <- system.file("examples", "zillow_or.geojson", package = "geojsonlint")
#' geojson_lint(x = as.location(file))
#'
#' # A URL
#' url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
#' geojson_lint(as.location(url))
#'
#' # toggle whether reason for validation failure is given back
#' geojson_lint('{ "type": "FeatureCollection" }')
#' geojson_lint('{ "type": "FeatureCollection" }', inform = TRUE)
#'
#' # toggle whether to stop with error message
#' geojson_lint('{ "type": "FeatureCollection" }')
#' geojson_lint('{ "type": "FeatureCollection" }', inform = TRUE)
#' if (interactive()) {
#'   geojson_lint('{ "type": "FeatureCollection" }', error = TRUE)
#' }
#' }
geojson_lint <- function(x, inform = FALSE, error = FALSE, ...) {
  UseMethod("geojson_lint")
}

#' @export
geojson_lint.default <- function(x, inform = FALSE, error = FALSE, ...) {
  stop("no geojson_lint method for ", class(x), call. = FALSE)
}

#' @export
geojson_lint.character <- function(x, inform = FALSE, error = FALSE, ...) {
  if (!jsonlite::validate(x)) stop("invalid json string", call. = FALSE)
  res <- c_post(geojsonlint_url(), body = x, ...)
  req_proc(res, inform, error)
}

#' @export
geojson_lint.location <- function(x, inform = FALSE, error = FALSE, ...) {
  on.exit(close_conns())
  res <- switch(
    attr(x, "type"),
    file = c_post(geojsonlint_url(), body = crul::upload(x[[1]]), ...),
    url = c_get(geojsonlint_url(), args = list(url = x[[1]]), ...)
  )
  req_proc(res, inform, error)
}

#' @export
geojson_lint.json <- function(x, inform = FALSE, error = FALSE, ...) {
  req_proc(write_post(x, ...), inform, error)
}

#' @export
geojson_lint.geojson <- function(x, inform = FALSE, error = FALSE, ...) {
  req_proc(write_post(unclass(x), ...), inform, error)
}

# helpers -----------------------------------
write_post <- function(x, inform, ...) {
  on.exit(close_conns())
  file <- tempfile(fileext = ".geojson")
  suppressMessages(gj_write(x, file = file))
  c_post(geojsonlint_url(), body = crul::upload(file), ...)
}

req_proc <- function(x, inform, error) {
  x$raise_for_status()
  res <- jsonlite::fromJSON(x$parse("UTF-8"))
  if (error && res$status == "error") {
    stop("invalid GeoJSON \n    - ", res$message, call. = FALSE)
  } else {
    if (res$status == "ok") {
      return(TRUE)
    } else {
      if (inform) {
        tmp <- FALSE
        attr(tmp, "errors") <- data.frame(rev(res), stringsAsFactors = FALSE)
        return(tmp)
      } else {
        return(FALSE)
      }
    }
  }
}

geojsonlint_url <- function() "http://geojsonlint.com/validate"
