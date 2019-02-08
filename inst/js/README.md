# JS dependencies

## geojsonhint

Currently (as of 2019-02-08) using geojsonhint v2.1.0

To recreate `inst/js/geojsohint.js`:

Install `geojsonhint` NPM library

```
npm install -g @mapbox/geojsonhint
```

Browserify

```
echo "global.geojsonhint = require('geojsonhint');" > in.js
browserify in.js -o geojsonhint.js
```

Copy js file into the `inst/js` directory in the `geojsonlint` package

```
cp geojsonhint.js geojsonlint/inst/js
```
