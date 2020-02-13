## Test environments

* local OS X install, R 3.6.2
* ubuntu 16.04 (on travis-ci), R 3.6.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

* I have run R CMD check on the 3 downstream dependencies. (Summary at <https://github.com/ropensci/geojsonlint/blob/master/revdep/README.md>). No problems were found.

---

This version fixes a failing check on CRAN checks for an example; in addition, a function is made defunct as the web service it used has gone away.

I expect there to be failures in revdepchecks for sen2r. Like my recent geojsonio CRAN submission, geojsonio no longer relies on rgdal causing sen2r to fail because it doesn't correctly use rgdal conditionally. I expect the same thing to happen here because this package does not use rgdal either. If there's sen2r failures due to rgdal, that's unrelated to this package.

Thanks! 
Scott Chamberlain
