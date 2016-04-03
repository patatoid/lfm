@App.controller('MainController', ['$scope', 'ArtistService', ($scope, ArtistService)->
  $scope.artist = new ArtistService()
  $scope.searchResults = [ ]
  $scope.searchArtist = (q)->
    $scope.loading = true
    ArtistService.search(q).then(
      (data)->
        $scope.loading = false
        $scope.searchResults = data
      ->
        $scope.loading = false
    )
])
