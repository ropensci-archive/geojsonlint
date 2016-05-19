#' Validate GeoJSON using geojsonlint.com web service
#' 
#' @export
#' @param x Input, a geojson character string, json object, or file or
#' url pointing to one of the former
#' @param verbose (logical) When geojson is invalid, return reason why (\code{TRUE}) or don't 
#' return reason (\code{FALSE}). Default: \code{FALSE}
#' @param error (logical) Throw an error on parse failure? If \code{TRUE}, then 
#' function returns \code{TRUE} on success, and \code{stop} with the 
#' error message on error. Default: \code{FALSE}
#' @param ... curl options passed on to \code{\link[httr]{GET}} or
#' \code{\link[httr]{POST}}
#'
#' @details Uses the web service at \url{http://geojsonlint.com}
#' 
#' @return \code{TRUE} or \code{FALSE}. If \code{verbose=TRUE} an attribute
#' of name \code{errors} is added with error information
#'
#' @examples \dontrun{
#' # From a json character string
#' geojson_lint(x = '{"type": "Point", "coordinates": [-100, 80]}') # good
#' geojson_lint(x = '{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}') # bad
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
#' geojson_lint('{ "type": "FeatureCollection" }', verbose = TRUE)
#' 
#' # toggle whether to stop with error message
#' geojson_lint('{ "type": "FeatureCollection" }')
#' geojson_lint('{ "type": "FeatureCollection" }', verbose = TRUE)
#' if (interactive()) {
#'   geojson_lint('{ "type": "FeatureCollection" }', error = TRUE)
#' }
#' }
geojson_lint <- function(x, verbose = FALSE, error = FALSE, ...) {
  UseMethod("geojson_lint")
}

#' @export
geojson_lint.default <- function(x, verbose = FALSE, error = FALSE, ...) {
  stop("no geojson_lint method for ", class(x), call. = FALSE)
}

#' @export
geojson_lint.character <- function(x, verbose = FALSE, error = FALSE, ...) {
  if (!jsonlite::validate(x)) stop("invalid json string", call. = FALSE)
  res <- httr::POST(geojsonlint_url(), body = x, ...)
  req_proc(res, verbose, error)
}

#' @export
geojson_lint.location <- function(x, verbose = FALSE, error = FALSE, ...) {
  on.exit(close_conns())
  res <- switch(attr(x, "type"),
                file = httr::POST(geojsonlint_url(), body = httr::upload_file(x[[1]]), ...),
                url = httr::GET(geojsonlint_url(), query = list(url = x[[1]]), ...))
  req_proc(res, verbose, error)
}

#' @export
geojson_lint.json <- function(x, verbose = FALSE, error = FALSE, ...) {
  req_proc(write_post(x, ...), verbose, error)
}

#' @export
geojson_lint.geojson <- function(x, verbose = FALSE, error = FALSE, ...) {
  req_proc(write_post(unclass(x), ...), verbose, error)
}

# helpers -----------------------------------
write_post <- function(x, verbose, ...) {
  on.exit(close_conns())
  file <- tempfile(fileext = ".geojson")
  suppressMessages(gj_write(x, file = file))
  httr::POST(geojsonlint_url(), body = httr::upload_file(file), ...)
}

req_proc <- function(x, verbose, error) {
  httr::stop_for_status(x)
  res <- jsonlite::fromJSON(httr::content(x, "text", encoding = "UTF-8"))
  if (error && res$status == "error") {
    stop("invalid GeoJSON \n    - ", res$message, call. = FALSE)
  } else {
    if (res$status == "ok") {
      return(TRUE)
    } else {
      if (verbose) {
        tmp <- FALSE
        attr(tmp, "errors") <- data.frame(rev(res), stringsAsFactors = FALSE)
        return(tmp)
      } else {
        return(FALSE)
      }
    }
  }
}

geojsonlint_url <- function() 'http://geojsonlint.com/validate'
