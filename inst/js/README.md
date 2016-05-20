# JS dependencies

## geojsonhint

Currently (2016-05-20) using geojsonhint v1.2.1

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
