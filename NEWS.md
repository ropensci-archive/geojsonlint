geojsonlint 0.4.0
=================

### DEFUNCT

* `geojson_lint()` is now defunct; the geojsonlint.com API appears to be gone and there's no sign of it coming back (#20)

## MINOR IMPROVEMENTS

* cran checks identified a failing example - resulting from occassional github bad response - only run these examples if interactive (#19)


geojsonlint 0.3.0
=================

## MINOR IMPROVEMENTS

* update JS library `geojsonhint` to `v2.1.0` (#11)
* replace `httr` with `crul` (#12)
* the parameter `verbose` replaced with `inform` throughout the package. take note if you have `verbose` parameter in use in any R code


geojsonlint 0.2.0
=================

## NEW FEATURES

* Now using a new version of the JS library `geojsonhint` (`v2.0.0-beta2`)
(#9) - see `geojsonhint` Changelog for changes to the JS library:
<https://github.com/mapbox/geojsonhint/blob/master/CHANGELOG.md>


geojsonlint 0.1.0
=================

## NEW FEATURES

* released to CRAN
