@App.controller('MapController', ['$scope', 'ArtistService', ($scope, ArtistService)->
  $scope.$watch(
    'search'
    (newSearch, oldSearch)->
      newSearch.artist.similar(newSearch).then (searcher)->
        window.force.nodes([])
        window.force.links([])
        $('.node').remove()
        $('.link').remove()
        $('.label').remove()
        window.force.start()
        window.force.nodes(searcher.artists)
        links = []
        for link in searcher.links
          links.push {
            source: searcher.artists.indexOf(
              searcher.artists.filter((e)-> e.mbid == link[0]).pop()
            )
            target: searcher.artists.indexOf(
              searcher.artists.filter((e)-> e.mbid == link[1]).pop()
            )
            weight: link[2]
          }
        window.force.links(links)
        window.force.start()
    true
  )
])
