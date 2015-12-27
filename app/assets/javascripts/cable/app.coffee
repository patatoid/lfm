#= require cable
# 
# @App = {}
# @App.cable = Cable.createConsumer('ws://localhost:3000/websocket')
# 
# @App.cable.subscriptions.create('MapChannel',
#   connected: ->
#     console.log this
#   received: (data)->
#     parent = data[0]
#     for similarity, artist of data[1]
#       target = null
#       cnode = force.nodes().filter((e)-> e.mbid == artist.mbid)[0]
#       unless cnode
#         node = {}
#         node.x = $(window).height() / 2
#         node.y = $(window).width() / 2
#         node.name = artist.name
#         node.mbid = artist.mbid
#         node.listenings = artist.listenings
# 
#         force.nodes().push(node)
#         maxListenings = Math.max.apply(
#           null
#           force.nodes().map((e)-> e.listenings)
#         )
#         for node in force.nodes()
#           node.radius = 20 * node.listenings / maxListenings
#         target = force.nodes().length - 1
#       else
#         target = cnode.index
# 
#       source = force.nodes().filter((e)-> e.mbid == parent.mbid)[0]
#     
#       force.links().push({
#         source: source.index,
#         target: target,
#         weight: parseFloat(similarity)
#       })
#       force.start()
# 
# )
