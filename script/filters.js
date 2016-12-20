var jsts = require('jsts'),
    fs = require('fs')


var state = JSON.parse(fs.readFileSync('oregon.json', 'utf-8')),
    grid  = JSON.parse(fs.readFileSync('grid.json', 'utf-8'))

var reader = new jsts.io.GeoJSONReader()
var geo1 = reader.read(state.geometry),
    geo2 = reader.read(grid)

geo2.features.forEach(function(f) {
  console.log(geo1.intersection(f.geometry).isEmpty())
})
