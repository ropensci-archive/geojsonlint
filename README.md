geojsonlint
===========



[![cran checks](https://cranchecks.info/badges/worst/geojsonlint)](https://cranchecks.info/pkgs/geojsonlint)
[![Build Status](https://api.travis-ci.org/ropensci/geojsonlint.png)](https://travis-ci.org/ropensci/geojsonlint)
[![codecov.io](https://codecov.io/github/ropensci/geojsonlint/coverage.svg?branch=master)](https://codecov.io/github/ropensci/geojsonlint?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/geojsonlint)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/geojsonlint)](https://cran.r-project.org/package=geojsonlint)

GeoJSON linters available in `geojsonlint`

* [GeoJSON hint JS library](https://www.npmjs.com/package/geojsonhint) - via `geojson_hint()` - currently using `geojsonhint` `v1.2.1`
* [is-my-json-valid JS library](https://www.npmjs.com/package/is-my-json-valid) - via `geojson_validate()`

Both functions return the same outputs. If the GeoJSON is valid, they return `TRUE`.
If the GeoJSON is invalid, they return `FALSE`, plus reason(s) that the GeoJSON is invalid
in an attribute named _errors_ as a data.frame. The fields in the data.frame's are not
the same across functions unfortunately, but they can be easily coerced to combine via
e.g., `plyr::rbind.fill` or `dplyr::bind_rows` or `data.table::rbindlist(fill = TRUE)`

The parameters for the three functions are similar, though `geojson_validate()` has an
extra parameter `greedy` that's not available in the others.

## Installation

from CRAN


```r
install.packages("geojsonlint")
```

Dev version


```r
remotes::install_github("ropensci/geojsonlint")
```


```r
library("geojsonlint")
```

## Good GeoJSON

geojsonhint JS library


```r
geojson_hint(x = '{"type": "Point", "coordinates": [-100, 80]}')
#> [1] TRUE
```

is-my-json-valid JS library


```r
geojson_validate(x = '{"type": "Point", "coordinates": [-100, 80]}')
#> [1] TRUE
```

## Bad GeoJSON

geojsonhint JS library


```r
geojson_hint('{"type": "FooBar"}')
#> [1] FALSE
```

is-my-json-valid JS library


```r
geojson_validate('{ "type": "FeatureCollection" }')
#> [1] FALSE
```

## Bad GeoJSON - with reason for failure

geojsonhint JS library


```r
geojson_hint('{"type": "FooBar"}', inform = TRUE)
#> [1] FALSE
#> attr(,"errors")
#>   line                    message
#> 1    1 The type FooBar is unknown
```

is-my-json-valid JS library


```r
geojson_validate('{ "type": "FeatureCollection" }', inform = TRUE)
#> [1] FALSE
#> attr(,"errors")
#>   field                             message
#> 1  data no (or more than one) schemas match
```

## Bad GeoJSON - stop on validation failure

geojsonhint JS library


```r
geojson_hint('{"type": "FooBar"}', error = TRUE)
#> Error: Line 1
#>    - The type FooBar is unknown
```

is-my-json-valid JS library


```r
geojson_validate('{ "type": "FeatureCollection" }', error = TRUE)
#> Error: 1 error validating json:
#> 	- data: no (or more than one) schemas match
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/geojsonlint/issues).
* License: MIT
* Get citation information for `geojsonlint` in R doing `citation(package = 'geojsonlint')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/geojsonlint/blob/master/CODE_OF_CONDUCT.md
