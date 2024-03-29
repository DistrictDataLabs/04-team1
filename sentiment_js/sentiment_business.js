var margin = {top: 20, right: 20, bottom: 30, left: 40},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

    // setup x
var xValue = function(d) { return d.Sentiment;}, // data -> value
    xScale = d3.scale.linear().range([0, width]), // value -> display
    xMap = function(d) { return xScale(xValue(d));}, // data -> display
    xAxis = d3.svg.axis().scale(xScale).orient("bottom"); 

//var yValue = function(d) { return d.Sentences;}, // data -> value
//var yValue = function(d, i) { return i;}, // data -> value
var yValue = function(d) { return d.countIndex;}, // data -> value
    yScale = d3.scale.linear().range([height, 0]), // value -> display
    yMap = function(d) { return yScale(yValue(d));}, // data -> display
    yAxis = d3.svg.axis().scale(yScale).orient("left");


// setup fill color
//var cValue = function(d) { return d.category;},
  var  color = d3.scale.category10(); 
 // var color = d3.rgb("#ff9900");  // Pass in Hex

//  var color = d3.rgb(12, 67, 199);  // Red, Green, Blue
 // var color = d3.hsl(0, 100, 50);  //  Hue-Saturation-Lightness  (e.g. red)
 // var color = d3.hcl(-97, 32, 52);  // steelblue
 // var color = d3.lab(52, -4, -32);  // Lab color space (l, a, b); steelblue
//  var  color		= d3.scale.ordinal()
 //    .range(colorbrewer.GnBu[9]);
    // .range(["#FF0000", "#009933" , "#0000FF"]);
  //   .range(["#0000FF", "#009933" , "#FF0000"]);


// add the graph canvas to the body of the webpage
var chart4 = d3.select("body").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// add the tooltip area to the webpage
var tooltip = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);


    // load data
d3.csv("js/stories_with_links_business.csv", function(error, data) {
      // change string (from CSV) into number format
      data.forEach(function(d) {
        d.Sentiment = +d.Sentiment;
        d.countIndex = +d.countIndex;
        //console.log(d);
      });

      // don't want dots overlapping axis, so add in buffer to data domain
      xScale.domain([d3.min(data, xValue)-1, d3.max(data, xValue)+1]);
      yScale.domain([d3.min(data, yValue)-1, d3.max(data, yValue)+1]);

      // x-axis
      chart4.append("g")
          .attr("class", "x axis")
          .attr("transform", "translate(0," + height + ")")
          .call(xAxis)
        .append("text")
          .attr("class", "label")
          .attr("x", width)
          .attr("y", -6)
          .style("text-anchor", "end")
          .text("Sentiment Score");

      // y-axis
      chart4.append("g")
          .attr("class", "y axis")
          .call(yAxis)
        .append("text")
          .attr("class", "label")
          .attr("transform", "rotate(-90)")
          .attr("y", 6)
          .attr("dy", ".71em")
          .style("text-anchor", "end");
        //  .text("Number of Sentences");

      // draw dots
      chart4.selectAll(".dot")
          .data(data)
        .enter()
        .append("a")
        .attr("xlink:href", function(d) {return d.link})
        .append("circle")
          .attr("class", "dot")
          .attr("r", 3.5)
          .attr("cx", xMap)
          .attr("cy", yMap)
          
   //       .style("fill", function(d) { return color(cValue(d));})
          .style("fill", function(d) { return color(d.category);})
          .on("mouseover", function(d) {
              tooltip.transition()
                   .duration(200)
                   .style("opacity", .9);
              tooltip.html(d.title + "<br/> (" + xValue(d) + " , " + d.date + ")")
                   .style("left", (d3.event.pageX + 5) + "px")
                   .style("top", (d3.event.pageY - 28) + "px");
          })
          .on("mouseout", function(d) {
              tooltip.transition()
                   .duration(500)
                   .style("opacity", 0);
          });

      // draw legend
//      var legend = chart4.selectAll(".legend")
//          .data(color.domain())
//        .enter().append("g")
//          .attr("class", "legend")
//          .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });
//
//      // draw legend colored rectangles
//      legend.append("rect")
//          .attr("x", width - 18)
//          .attr("width", 18)
//          .attr("height", 18)
//          .style("fill", color);
//
//      // draw legend text
//      legend.append("text")
//          .attr("x", width - 24)
//          .attr("y", 9)
//          .attr("dy", ".35em")
//          .style("text-anchor", "end")
//          .text(function(d) {return d;})
    });
