@App.config ($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise("/")
  $stateProvider
    .state('main', {
          url: "/",
          templateUrl: 'ng/components/main/index.html'
        })
