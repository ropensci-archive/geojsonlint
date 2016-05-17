<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{geojsonlint vignette}
%\VignetteEncoding{UTF-8}
-->



geojsonlint vignette
====================

Tools for linting 'GeoJSON'.

Package API:

* `geojson_lint()` - [GeoJSON lint web service](http://geojsonlint.com/)
* `geojson_hint()` - [GeoJSON hint JS library](https://www.npmjs.com/package/geojsonhint)
* `geojson_validate()` - [is-my-json-valid JS library](https://www.npmjs.com/package/is-my-json-valid) using a GeoJSON
schema from [https://github.com/SchemaStore/schemastore](https://github.com/SchemaStore/schemastore)

## Install

Stable version from CRAN


```r
install.packages("geojsonlint")
```

Development version from GitHub


```r
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
#>   status                               message
#> 1  error "FooBar" is not a valid GeoJSON type.
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
