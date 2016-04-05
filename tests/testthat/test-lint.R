context("geojson_hint")

test_that("geojson_hint works with character inputs", {
  a <- geojson_hint('{"type": "FooBar"}')
  expect_is(a, "list")
  expect_is(a$message, "character")
  expect_equal(a$message, "The type FooBar is unknown")

  # valid
  expect_equal(geojson_hint('{"type": "Point", "coordinates": [-80,40]}'), "valid")

  # invalid
  expect_is(geojson_hint('{ "type": "FeatureCollection" }'), "list")
  expect_is(geojson_hint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}'), "list")
})

test_that("geojson_hint works with file inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonlint")
  d <- geojson_hint(as.location(file))
  expect_is(as.location(file), "location")
  expect_is(d, "character")
  expect_equal(d, "valid")
})

test_that("geojson_hint works with url inputs", {
  skip_on_cran()

  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e <- geojson_hint(as.location(url))
  expect_is(as.location(url), "location")
  expect_is(e, "character")
  expect_equal(e, "valid")
})

test_that("geojson_hint works with json inputs", {
  x <- jsonlite::minify('{ "type": "FeatureCollection" }')
  f <- geojson_hint(x)
  expect_is(x, "json")
  expect_is(f, "list")
  expect_equal(f$message, "\"features\" property required")
})
