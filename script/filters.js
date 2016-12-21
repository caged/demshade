#!/bin/bash
# var jsts = require('jsts'),
#     fs = require('fs')
#
#
# var state = JSON.parse(fs.readFileSync('oregon.json', 'utf-8')),
#     grid  = JSON.parse(fs.readFileSync('grid.json', 'utf-8'))
#
# var reader = new jsts.io.GeoJSONReader()
# var geo1 = reader.read(state.geometry),
#     geo2 = reader.read(grid)
#
# geo2.features.forEach(function(f) {
#   console.log(geo1.intersection(f.geometry).isEmpty())
# })
#
# module.exports = function intersects(geom1, geom2) {
#   var reader = new jsts.io.GeoJSONReader()
#   geom1 = reader.read(JSON.parse(geom1))
#   geom2 = reader.read(JSON.parse(geom2))
#
#   return !geom2.intersection(geom1).isEmpty()
# }



ndjson-join 'true' <(cat oregon.json) <(shp2json -n data/shp/arc_reference/ned_1arcsec_g.shp) \
  | ndjson-filter -r jsts 'function(d) { var r = new jsts.io.GeoJSONReader(), g1 = r.read(d[0].geometry), g2 = r.read(d[1].geometry); return !g1.intersection(g2).isEmpty() }.call(this, d)' \
  | ndjson-map 'd[1]'
# var r = new jsts.io.GeoJSONReader(), g1 = r.read(d[0]), g2 = r.read(d[1]); return !g1.intersection(g2).isEmpty()
