@App.config ($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise("/map")
  $stateProvider
    .state('main', {
      abstract: true
      controller: 'MainController'
      templateUrl: 'ng/components/main/index.html'
    }).state('main.map', {
      url: '/map'
      controller: 'MapController'
      templateUrl: 'ng/components/artists/map.html'
    })
