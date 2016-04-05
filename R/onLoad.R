ct <- NULL
.onLoad <- function(libname, pkgname){
  ct <<- V8::new_context();
  ct$source(system.file("js/geojsonhint.js", package = pkgname))
}
