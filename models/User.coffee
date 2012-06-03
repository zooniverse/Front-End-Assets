define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  App = require './App'
  Authentication = require 'zooniverse/controllers/Authentication'
  Favorite = require './Favorite'
  Recent = require './Recent'

  class User extends Spine.Model
    @configure 'User', 'zooniverseId', 'name', 'apiKey', 'finishedTutorial', 'favorites', 'recents'

    @current: null

    @signIn: (user) =>
      return if user is @current
      @current = user
      @current?.refreshFavorites()
      @current?.refreshRecents()
      @trigger 'sign-in', @current

    @signOut: =>
      @current?.destroy()
      @signIn null

    @fromJSON: (raw) ->
      super
        id: raw.id
        zooniverseId: raw.zooniverse_id
        name: raw.name
        apiKey: raw.api_key

    constructor: ->
      super
      @favorites ?= []
      @recents ?= []

      Favorite.bind 'persist destroy', @refreshFavorites
      Recent.bind 'persist destroy', @refreshRecents

    refreshSomething: (attribute, model) =>
      refresh = new $.Deferred

      url = """
        #{App.first().host}
        /projects/#{App.first().projects[0].id}
        /users/#{@id}
        /#{attribute}
      """.replace '\n', '', 'g'

      get = $.getJSON url

      get.done (response) =>
        @[attribute] = (model.fromJSON raw for raw in response)
        @trigger "refresh-#{attribute}"

        refresh.resolve @[attribute]

      refresh.promise()

    refreshFavorites: =>
      @refreshSomething 'favorites', Favorite

    refreshRecents: =>
      @refreshSomething 'recents', Recent

    # Send authentication header to Ouroboros when logged in.
    $.ajaxSetup beforeSend: (xhr, settings) =>
      if @current? and !!~settings.url.indexOf App.first().host
        # TODO: Use a proper base-64 encoder.
        # http://stringencoders.googlecode.com/svn/trunk/javascript/base64.js
        auth = btoa "#{@current.name}:#{@current.apiKey}"
        xhr.setRequestHeader 'Authorization', "Basic #{auth}"

    Authentication.bind 'login', (data) =>
      @signIn @fromJSON data

    Authentication.bind 'logout', =>
      @signOut()

  module.exports = User
