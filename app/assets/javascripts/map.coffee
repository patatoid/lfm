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

  collide = (node)->
    r = node.radius + 16
    nx1 = node.x - r
    nx2 = node.x + r
    ny1 = node.y - r
    ny2 = node.y + r
    (quad, x1, y1, x2, y2)->
      if (quad.point && (quad.point != node))
        x = node.x - quad.point.x
        y = node.y - quad.point.y
        l = Math.sqrt(x * x + y * y)
        r = node.radius + quad.point.radius
        if (l < r)
          l = (l - r) / l * .5
          node.x -= x *= l
          node.y -= y *= l
          quad.point.x += x
          quad.point.y += y
      x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1

  draw = () ->
    node = vis.selectAll(".node").data(force.nodes()).enter().insert("g")
      .attr("class", "node")
      .attr("id", (d) -> 'node_' + d.artist_id)
    node.append("circle")
    node.append("text")
        .attr("class", "label")
        .attr("fill", "red")
        .attr('text-anchor', 'middle')
        .text((d)-> d.name)
    vis.selectAll('.link').data(force.links()).enter().insert("line")
      .attr("class", 'link')
      .attr('stroke', 'black')
      .attr('stroke-opacity', '0.5')
  
  render = () ->
    nodes = force.nodes()
    q = d3.geom.quadtree(nodes)

    q.visit(collide node) for node in nodes

    vis.selectAll(".node")
      .attr("transform", (d)-> "translate(" + d.x + "," + d.y + ")")
      .select('circle')
      .attr('r', (d)-> d.radius)

    vis.selectAll(".link")
      .attr("x1", (d)-> d.source.x )
      .attr("y1", (d)-> d.source.y )
      .attr("x2", (d)-> d.target.x )
      .attr("y2", (d)-> d.target.y )
    draw()

  window.force = d3.layout.force()
    .charge(-100)
    .linkDistance((e, index)-> 50 * Math.pow(1 / e.weight, 2))
    .size([width, height])
    .nodes([{ x: 338.5, y: 677, name: "Selah Sue", mbid: "fefeb63b-9430-4fe8-a332-0c400351af50", listenings: 19373573, radius: 50 }])
    .links([])
    .on('tick', () -> render())
  draw()
  force.start()
)
