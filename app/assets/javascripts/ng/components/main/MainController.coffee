@App.controller('MainController', ['$scope', 'ArtistService', ($scope, ArtistService)->
  $scope.search = {artist: new ArtistService()}
  $scope.searchResults = [ ]
  $scope.searchArtist = (q)->
    $scope.loading = true
    ArtistService.search(q).then(
      (artists)->
        $scope.loading = false
        $scope.searchResults = artists
      ->
        $scope.loading = false
    )
])
