const el = d3.select(".js-vis"),
    ewidth = parseFloat(el.style("width")),
    eheight = parseFloat(el.style("height"))

const margin = { top: 0, right: 0, bottom: 0, left: 0 },
    width = ewidth - margin.left - margin.right,
    height = eheight - margin.top - margin.bottom

var projection = d3.geoConicConformal()
  .parallels([43, 45.5])
  .rotate([120.5, 0])

var path = d3.geoPath()
  .projection(projection)

var pathel = d3.select(null)
var sliders = d3.selectAll('.js-slider')

const vis = el.append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
.append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

d3.json("/oregon-topo.json", function(error, oregon) {
  if (error) throw error;
  const feature = topojson.feature(oregon, oregon.objects.state)

  projection.fitExtent([[0, 0], [width, height]], feature)

  pathel = vis.append('path')
    .datum(feature)
    .attr('class', 'state')
    .attr('d', path)

  function reproject(el) {
    const parent = d3.select(this.parentNode)
    const x = parent.select('.js-slider[data-extent="x0"]').node().value
    const y = parent.select('.js-slider[data-extent="y0"]').node().value

    projection
      .fitExtent([[x, y], [width, height]], feature)

    pathel.transition()
      .attr('d', path)

  }

  sliders.on('change', reproject)

});
