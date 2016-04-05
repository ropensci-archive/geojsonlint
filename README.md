geojsonlint
===========



[![Build Status](https://api.travis-ci.org/ropenscilabs/geojsonlint.png)](https://travis-ci.org/ropenscilabs/geojsonlint)
[![codecov.io](https://codecov.io/github/ropenscilabs/geojsonlint/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/geojsonlint?branch=master)

GeoJSON linters available in `geojsonlint`

* [GeoJSON lint web service](http://geojsonlint.com/)
* [GeoJSON hint JS library](https://www.npmjs.com/package/geojsonhint)

## Installation


```r
install.packages("devtools")
devtools::install_github("ropenscilabs/geojsonlint")
```


```r
library("geojsonlint")
```

## geojsonlint.com web service

Bad GeoJSON


```r
geojson_lint(x = '{"type": "Rhombus", "coordinates": [[1, 2], [3, 4], [5, 6]]}')
#> $message
#> [1] "\"Rhombus\" is not a valid GeoJSON type."
#> 
#> $status
#> [1] "error"
```

Good GeoJSON


```r
geojson_lint(x = '{"type": "Point", "coordinates": [-100, 80]}')
#> $status
#> [1] "ok"
```

## geojsonhint JS module

Bad GeoJSON


```r
geojson_hint('{"type": "FooBar"}')
#> $message
#> [1] "The type FooBar is unknown"
#> 
#> $line
#> [1] 1
```


```r
geojson_hint('{ "type": "FeatureCollection" }')
#> $message
#> [1] "\"features\" property required"
#> 
#> $line
#> [1] 1
```


```r
geojson_hint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}')
#> $message
#> [1] "\"coordinates\" property required"
#> 
#> $line
#> [1] 1
```

Good GeoJSON


```r
geojson_hint('{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Point",
        "coordinates": [
          -100.8984375,
          41.508577297439324
        ]
      }
    }
  ]
}')
#> [1] "valid"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropenscilabs/geojsonlint/issues).
* License: MIT
* Get citation information for `geojsonlint` in R doing `citation(package = 'geojsonlint')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
