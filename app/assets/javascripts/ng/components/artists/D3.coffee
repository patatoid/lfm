@App.directive('d3', -> {
  scope: true
  link: (scope, elt, attr)->
    $container = $(elt)
    
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
          xSpacing = (quad.point.width + node.width) / 2
          ySpacing = (quad.point.height + node.height) / 2
          absX = Math.abs(x)
          absY = Math.abs(y)
          if (absX < xSpacing && absY < ySpacing)
            l = Math.sqrt(x * x + y * y)
            lx = (absX - xSpacing) / l
            ly = (absY - ySpacing) / l
            if (Math.abs(lx) > Math.abs(ly))
              lx = 0
            else
              ly = 0
            node.x -= x *= lx
            node.y -= y *= ly
            quad.point.x += x
            quad.point.y += y
            true
          if x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1
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
            true

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
      node.each (d)->
        d.width = $(this).find('text').width() + 15
        d.height = $(this).find('text').height() + 15
      vis.selectAll('.link').data(force.links()).enter().insert("line")
        .attr("class", 'link')
        # .attr('stroke', '#eeeeee')
        .attr('stroke-opacity', '0.5')
    
    render = () ->
      nodes = force.nodes()
      q = d3.geom.quadtree(nodes)

      q.visit(collide node) for node in nodes

      max = Math.max.apply(null, window.force.nodes().map (e)-> e.listenings )
      for node in window.force.nodes()
        node.radius = (node.listenings / max)* 50

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
      .linkDistance((e, index)-> 300 * (1 - e.weight))
      .size([width, height])
      .nodes([])
      .links([])
      .on('tick', () -> render())
    draw()
    force.start()
})
