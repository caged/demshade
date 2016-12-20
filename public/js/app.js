"use strict";

var el = d3.select(".js-vis"),
    ewidth = parseFloat(el.style("width")),
    eheight = parseFloat(el.style("height"));

var margin = { top: 20, right: 0, bottom: 0, left: 0 },
    width = ewidth - margin.left - margin.right,
    height = eheight - margin.top - margin.bottom;

var vis = el.append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

d3.json("/oregon-topo.json", function (error, oregon) {
  if (error) throw error;
  var feature = topojson.feature(oregon, oregon.objects.state);
  // projection.fitSize([width, height], feature)

  var path = d3.geoPath().projection(d3.geoConicConformal().parallels([43, 45.5]).rotate([120.5, 0]).fitExtent([[160, 20], [width, height]], feature));

  vis.append('path').datum(feature).attr('class', 'state').attr('d', path);

  //
  // context.beginPath();
  // path(topojson.mesh(us));
  // context.stroke();
});