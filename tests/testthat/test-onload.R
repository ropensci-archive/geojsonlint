context("onload")

obj_names <- c('eval', 'assign', 'validate', 'call',
               'reset', 'source', 'console', 'get')

test_that("onload for geojsonhint worked", {
  expect_is(ct, "V8")
  expect_true(all(obj_names %in% ls(ct)))
  expect_true(any(grepl("geojsonhint",
    ct$get(V8::JS("Object.keys(global)")))))

  expect_equal(ct$eval("geojsonhint"), "[object Object]")
  expect_true(grepl("function hint\\(str, options\\)",
    ct$eval("geojsonhint.hint")))
})
