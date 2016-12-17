"use strict";

var el = d3.select(".js-vis"),
    ewidth = parseFloat(el.style("width")),
    eheight = parseFloat(el.style("height"));

var margin = { top: 20, right: 20, bottom: 20, left: 50 },
    width = ewidth - margin.left - margin.right,
    height = eheight - margin.top - margin.bottom;

// Generate fake data
var random = d3.randomNormal(0, 0.2),
    data = d3.range(300).map(function () {
  return [random() + Math.sqrt(3), random() + 1];
});

var x = d3.scaleLinear().domain(d3.extent(data, function (d) {
  return d[0];
})).range([0, width]);

var y = d3.scaleLinear().domain(d3.extent(data, function (d) {
  return d[1];
})).range([height, 0]);

var xax = d3.axisTop(x),
    yax = d3.axisLeft(y);

var vis = el.append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

vis.append("g").call(xax);

vis.append("g").call(yax);

var nodes = vis.append("g").attr("class", "nodes");

nodes.selectAll(".node").data(data).enter().append("circle").attr("r", 3).attr("cx", function (d) {
  return x(d[0]);
}).attr("cy", function (d) {
  return y(d[1]);
}).style("fill", function () {
  return "hsl(" + Math.random() * 360 + ", 50%, 50%)";
});