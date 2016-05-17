all: move rmd2md

move:
		cp inst/vign/geojsonlint_vignette.md vignettes/

rmd2md:
		cd vignettes;\
		mv geojsonlint_vignette.md geojsonlint_vignette.Rmd
