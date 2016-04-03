@App.controller('MapController', ['$scope', 'ArtistService', ($scope, ArtistService)->
  $scope.$watch(
    'artist'
    (newArtist, oldArtist)->
      $scope.similar = artist.similar()
  )
])
