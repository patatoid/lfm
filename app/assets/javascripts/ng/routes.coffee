@App.config ($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise("/")
  $stateProvider
    .state('main', {
          url: "/",
          controller: 'MainController'
          templateUrl: 'ng/components/main/index.html'
        })
