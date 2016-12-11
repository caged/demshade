const el = d3.select(".js-vis"),
    ewidth = parseFloat(el.style("width")),
    eheight = parseFloat(el.style("height"))

const margin = { top: 20, right: 20, bottom: 20, left: 50 },
    width = ewidth - margin.left - margin.right,
    height = eheight - margin.top - margin.bottom

// Generate fake data
const random = d3.randomNormal(0, 0.2),
    data = d3.range(300).map(() => {
      return [random() + Math.sqrt(3), random() + 1];
    })

const x = d3.scaleLinear()
  .domain(d3.extent(data, d => d[0]))
  .range([0, width])

const y = d3.scaleLinear()
  .domain(d3.extent(data, d => d[1]))
  .range([height, 0])

const xax = d3.axisTop(x),
    yax = d3.axisLeft(y)

const vis = el.append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
.append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

vis.append("g")
  .call(xax)

vis.append("g")
  .call(yax)

var nodes = vis.append("g")
  .attr("class", "nodes")

nodes.selectAll(".node")
  .data(data)
.enter().append("circle")
  .attr("r", 3)
  .attr("cx", d => x(d[0]))
  .attr("cy", d => y(d[1]))
  .style("fill", () => "hsl(" + Math.random() * 360 + ", 50%, 50%)")
