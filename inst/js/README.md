# JS dependencies

## geojsonhint

Currently (as of 2016-10-12) using geojsonhint v2.0.0-beta2

To recreate `inst/js/geojsohint.js`:

Install `geojsonhint` NPM library

```
npm install geojsonhint
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
