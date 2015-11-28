#= require cable

@App = {}
@App.cable = Cable.createConsumer('ws://localhost:3000/websocket')

@App.cable.subscription.create('MapChannet',
  connected: ->
    console.log this
)
