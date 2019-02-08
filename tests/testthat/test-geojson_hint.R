context("geojson_hint")

test_that("geojson_hint works with character inputs", {
  a <- geojson_hint('{"type": "FooBar"}')
  expect_is(a, "logical")
  expect_false(a)
  
  # valid
  expect_true(geojson_hint('{"type": "Point", "coordinates": [-80,40]}'))

  # invalid
  expect_false(geojson_hint('{ "type": "FeatureCollection" }'))
  expect_false(geojson_hint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}'))
})

test_that("geojson_hint works when inform output", {
  a <- geojson_hint('{"type": "FooBar"}', inform = TRUE)
  expect_is(a, "logical")
  expect_false(a)
  
  expect_named(attributes(a), "errors")
  expect_named(attr(a, "errors"), c('line', 'message'))
  expect_equal(attr(a, "errors")$message, "The type FooBar is unknown")
  
  # valid
  expect_true(geojson_hint('{"type": "Point", "coordinates": [-80,40]}', inform = TRUE))
  
  # invalid
  bb <- geojson_hint('{ "type": "FeatureCollection" }', inform = TRUE)
  expect_is(bb, "logical")
  expect_false(bb)
  expect_is(attributes(bb)[[1]], "data.frame")
  
  cc <- geojson_hint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}', inform = TRUE)
  expect_is(cc, "logical")
  expect_false(cc)
  expect_is(attributes(cc)[[1]], "data.frame")
})

test_that("geojson_hint works with file inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonlint")
  d <- geojson_hint(as.location(file), inform = TRUE)
  expect_is(as.location(file), "location")
  expect_is(d, "logical")
  # with geojsonhint v2 library, now right hand rule checked
  expect_false(d)
  expect_match(attr(d, "errors")$message[1], "right-hand rule")
})

test_that("geojson_hint works with url inputs", {
  skip_on_cran()
  
  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e <- geojson_hint(as.location(url), inform = TRUE)
  expect_is(as.location(url), "location")
  expect_is(e, "logical")
  expect_false(e)
  expect_match(attr(e, "errors")$message[1], "right-hand rule")
})

test_that("geojson_hint works with json inputs", {
  x <- jsonlite::minify('{ "type": "FeatureCollection" }')
  expect_is(x, "json")
  
  # without inform
  f <- geojson_hint(x)
  expect_is(f, "logical")
  expect_false(f)
  expect_null(attributes(f))
  
  # with inform
  g <- geojson_hint(x, inform = TRUE)
  expect_is(g, "logical")
  expect_false(g)
  expect_is(attributes(g), "list")
  expect_equal(attr(g, "errors")$message, "\"features\" member required")
})
