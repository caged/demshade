const el = d3.select(".js-vis"),
    ewidth = parseFloat(el.style("width")),
    eheight = parseFloat(el.style("height"))

const margin = { top: 20, right: 20, bottom: 20, left: 50 },
    width = ewidth - margin.left - margin.right,
    height = eheight - margin.top - margin.bottom

var path = d3.geoPath()
    .projection(null)
    
// const x = d3.scaleLinear()
//   .domain(d3.extent(data, d => d[0]))
//   .range([0, width])

// const y = d3.scaleLinear()
//   .domain(d3.extent(data, d => d[1]))
//   .range([height, 0])

const vis = el.append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
.append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

// d3.json("https://d3js.org/us-10m.v1.json", function(error, us) {
//   if (error) throw error;
//
//   context.beginPath();
//   path(topojson.mesh(us));
//   context.stroke();
// });
