$(->
  $container = $('.map')
  
  height = $container.height()
  width = $container.width()
  
  outer = d3.select($container[0])
    .append('svg:svg')
    .attr("width", width)
    .attr("height", height)

  vis = outer
    .append('svg:g')

  draw = () ->
    vis.selectAll(".node").data(force.nodes()).enter().insert("circle")
      .attr("class", "node")
      .attr('r', '10')
      .attr("id", (d) -> 'node_' + d.artist_id)
    vis.selectAll('.link').data(force.links()).enter().insert("line")
      .attr("class", 'link')
  
  render = () ->
    nodes = force.nodes()
    q = d3.geom.quadtree(nodes)

    # q.visit(collide node) for node in nodes

    vis.selectAll(".node")
      .attr("cx", (d) -> d.x)
      .attr("cy", (d) -> d.y)

    vis.selectAll(".link")
      .attr("x1", (d)-> d.source.x )
      .attr("y1", (d)-> d.source.y )
      .attr("x2", (d)-> d.target.x )
      .attr("y2", (d)-> d.target.y )
    draw()

  window.force = d3.layout.force()
    .linkDistance((e, index)-> 10 * e.weight)
    .size([width, height])
    .nodes([{x: 100, y: 100}, {x: 200, y: 200}])
    .links([{source: 0, target: 1, weight: 1}])
    .on('tick', () -> render())
  draw()
  force.start()
)
