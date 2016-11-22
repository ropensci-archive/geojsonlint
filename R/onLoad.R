ct <- NULL
validate_geojson <- NULL
.onLoad <- function(libname, pkgname){
  validate_geojson <<- jsonvalidate::json_validator(system.file("schema/geojson.json", package = pkgname))
  ct <<- V8::v8();
  ct$source(system.file("js/geojsonhint.js", package = pkgname))
}
