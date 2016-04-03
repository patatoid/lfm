@App.controller('MapController', ['$scope', 'ArtistService', ($scope, ArtistService)->
  $scope.$watch(
    'search'
    (newSearch, oldSearch)->
      newSearch.artist.similar(newSearch).then (artists)->
        $scope.similar = artists
        console.log artists
    true
  )
])
