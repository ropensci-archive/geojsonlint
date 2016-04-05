context("geojson_lint")

test_that("geojson_lint works with character inputs", {
  a <- geojson_lint('{"type": "FooBar"}')
  expect_is(a, "list")
  expect_is(a$message, "character")
  expect_equal(a$message, "\"FooBar\" is not a valid GeoJSON type.")

  # listid
  expect_equal(geojson_lint('{"type": "Point", "coordinates": [-80,40]}')$status, "ok")

  # invalid
  expect_equal(geojson_lint('{ "type": "FeatureCollection" }')$status, "error")
  expect_equal(geojson_lint('{"type":"Point","geometry":{"type":"Point","coordinates":[-80,40]},"properties":{}}')$status, "error")
})

test_that("geojson_lint works with file inputs", {
  file <- system.file("examples", "zillow_or.geojson", package = "geojsonio")
  d <- geojson_lint(as.location(file))
  expect_is(as.location(file), "location")
  expect_is(d, "list")
  expect_equal(d$status, "ok")
})

test_that("geojson_lint works with url inputs", {
  skip_on_cran()

  url <- "https://raw.githubusercontent.com/glynnbird/usstatesgeojson/master/california.geojson"
  e <- geojson_lint(as.location(url))
  expect_is(as.location(url), "location")
  expect_is(e, "list")
  expect_equal(e$status, "ok")
})

test_that("geojson_lint works with json inputs", {
  x <- jsonlite::minify('{ "type": "FeatureCollection" }')
  f <- geojson_lint(x)
  expect_is(x, "json")
  expect_is(f, "list")
  expect_equal(f$message, "A FeatureCollection must have a \"features\" property.")
})
