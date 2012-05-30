define (require, exports, module) ->
  Spine = require 'Spine'
  Leaflet = require 'Leaflet'

  {delay} = require 'zooniverse/util'

  class Map extends Spine.Controller
    latitude: 41.9
    longitude: -87.6
    zoom: 10

    layers: null

    zoomControl: true
    scrollWheelZoom: false
    doubleClickZoom: false

    # Set these before use.
    apiKey: ''
    tilesId: 998

    map: null

    constructor: ->
      super

      throw new Error 'zooniverse/controllers/Map::apiKey is empty' unless @apiKey

      @layers ?= []
      @layers = [@layers] unless @layers instanceof Array

      @map = new Leaflet.Map @el.get(0),
        center: new Leaflet.LatLng @latitude, @longitude
        zoom: @zoom
        layers: [
          new Leaflet.TileLayer "http://{s}.tile.cloudmade.com/#{@apiKey}/#{@tilesId}/256/{z}/{x}/{y}.png"
          (new Leaflet.TileLayer url for url in @layers)...
        ]
        scrollWheelZoom: @scrollWheelZoom
        doubleClickZoom: @doubleClickZoom
        attributionControl: false
        zoomControl: @zoomControl

      # If the map isn't immediately visible, resize it after a bit.
      mapSize = @map.getSize()
      if 0 in [mapSize.x, mapSize.y] then delay 1000, @resized

    setCenter: (@latitude, @longitude) =>
      @map.setView new Leaflet.LatLng(@latitude, @longitude), @map.getZoom()

    setZoom: (@zoom) =>
      @map.setZoom @zoom

    addLayer: (url) =>
      @map.addLayer new L.TileLayer url

    resized: =>
      @map.invalidateSize()

  module.exports = Map
