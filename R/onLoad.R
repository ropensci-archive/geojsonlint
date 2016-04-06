ct <- NULL
.onLoad <- function(libname, pkgname){
  ct <<- V8::v8();
  ct$source(system.file("js/geojsonhint.js", package = pkgname))
}
