@App.factory('ArtistService', ['$http', '$q', ($http, $q)->
  Service = (params)->
    for k, v of params
      this[k] = v
    this
  Service.url = Routes.artists_path()

  Service.search = (q)->
    defer = $q.defer()
    $http.get(Routes.search_artists_path({q: q})).then (response)->
      defer.resolve(response.data.map (e)-> new Service(e))
    defer.promise

  Service.prototype.similar = (filters)->
    defer = $q.defer()
    $http.post(Routes.similar_artist_path({id: this.mbid || ''}), filters).then (response)->
      defer.resolve(response.data.map (e)-> new Service(e))
    defer.promise

  Service
])
