geojsonlint
===========



[![Build Status](https://api.travis-ci.org/ropenscilabs/geojsonlint.png)](https://travis-ci.org/ropenscilabs/geojsonlint)
[![codecov.io](https://codecov.io/github/ropenscilabs/geojsonlint/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/geojsonlint?branch=master)

GeoJSON linters available in `geojsonlint`

* [GeoJSON lint web service](http://geojsonlint.com/) - via `geojson_lint()`
* [GeoJSON hint JS library](https://www.npmjs.com/package/geojsonhint) - via `geojson_hint()` - currently using `geojsonhint` `v1.2.1`
* [is-my-json-valid JS library](https://www.npmjs.com/package/is-my-json-valid) - via `geojson_validate()`

All three functions return the same outputs. If the GeoJSON is valid, they return `TRUE`. 
If the GeoJSON is invalid, they return `FALSE`, plus reason(s) that the GeoJSON is invalid
in an attribute named _errors_ as a data.frame. The fields in the data.frame's are not 
the same across functions unfortunately, but they can be easily coerced to combine via
e.g., `plyr::rbind.fill` or `dplyr::bind_rows` or `data.table::rbindlist(fill = TRUE)`

The parameters for the three functions are similar, though `geojson_validate()` has an 
extra parameter `greedy` that's not available in the others, and `geojson_hint()` has
`...` parameter to pass on curl options as it works with a web service.

## Installation


```r
install.packages("devtools")
devtools::install_github("ropenscilabs/geojsonlint")
```


```r
library("geojsonlint")
```

## Good GeoJSON

geojsonlint.com web service


```r
geojson_lint(x = '{"type": "Point", "coordinates": [-100, 80]}')
#> [1] TRUE
```

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

geojsonlint.com web service


```r
geojson_lint('{"type": "FooBar"}')
#> [1] FALSE
```

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

geojsonlint.com web service


```r
geojson_lint('{"type": "FooBar"}', verbose = TRUE)
#> [1] FALSE
#> attr(,"errors")
#>                                 message status
#> 1 "FooBar" is not a valid GeoJSON type.  error
```

geojsonhint JS library


```r
geojson_hint('{"type": "FooBar"}', verbose = TRUE)
#> [1] FALSE
#> attr(,"errors")
#>   line                    message
#> 1    1 The type FooBar is unknown
```

is-my-json-valid JS library


```r
geojson_validate('{ "type": "FeatureCollection" }', verbose = TRUE)
#> [1] FALSE
#> attr(,"errors")
#>   field                             message
#> 1  data no (or more than one) schemas match
```

## Bad GeoJSON - stop on validation failure

geojsonlint.com web service


```r
geojson_lint('{"type": "FooBar"}', error = TRUE)
#> Error: invalid GeoJSON 
#>    - "FooBar" is not a valid GeoJSON type.
```

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

* Please [report any issues or bugs](https://github.com/ropenscilabs/geojsonlint/issues).
* License: MIT
* Get citation information for `geojsonlint` in R doing `citation(package = 'geojsonlint')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
