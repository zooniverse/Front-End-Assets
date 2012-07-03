define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'
  base64 = require 'base64'

  API = require 'zooniverse/API'
  config = require 'zooniverse/config'
  {delay, joinLines, remove} = require 'zooniverse/util'

  Authentication = require 'zooniverse/controllers/Authentication'
  Favorite = require './Favorite'
  Recent = require './Recent'

  class User extends Spine.Model
    @configure 'User', 'zooniverseId', 'name', 'apiKey', 'finishedTutorial', 'favorites', 'recents'

    @current: null

    @signIn: (user) =>
      return if user is @current
      @current = user

      if @current?
        auth = base64.encode "#{@current.name}:#{@current.apiKey}"
        API.headers['Authorization'] = "Basic #{auth}"
      else
        delete API.headers['Authorization']

      @trigger 'sign-in', @current
      @current?.refreshFavorites()
      @current?.refreshRecents()

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

      tutorialFinishers = JSON.parse localStorage.finishedTutorial || '[]'
      @finishedTutorial = @zooniverseId in tutorialFinishers

      Favorite.bind 'create', @onCreateFavorite
      Favorite.bind 'destroy', @onDestroyFavorite
      Recent.bind 'create', @onCreateRecent
      Recent.bind 'destroy', @onDestroyRecent

    refreshSomething: (attribute, model) =>
      refresh = new $.Deferred

      url = joinLines """
        /projects/#{config.app.projects[0].id}
        /users/#{@id}
        /#{attribute}
      """

      API.get url, (response) =>
        model.fromJSON raw for raw in response.reverse()
        @trigger "refresh-#{attribute}"

        refresh.resolve @[attribute]

      refresh.promise()

    refreshFavorites: =>
      @refreshSomething 'favorites', Favorite

    refreshRecents: =>
      @refreshSomething 'recents', Recent

    onCreateFavorite: (created) =>
      @favorites.push created
      @trigger 'add-favorite', created
      @trigger 'change'

    onDestroyFavorite: (destroyed) =>
      remove destroyed, from: @favorites
      @trigger 'remove-favorite', destroyed
      @trigger 'change'

    onCreateRecent: (created) =>
      @recents.push created
      @trigger 'change'

    onDestroyRecent: (destroyed) =>
      remove destroyed, from: @recents
      @trigger 'change'

    setFinishedTutorial: (@finished) ->
      finishers = JSON.parse localStorage.finishedTutorial || '[]'

      if @finished
        finishers.push @zooniverseId unless @zooniverseId in finishers
      else
        remove @zooniverseId, from: finishers

      localStorage.finishedTutorial = JSON.stringify finishers

    persist: =>
      # TODO

    Authentication.bind 'login', (data) =>
      @signIn @fromJSON data

    Authentication.bind 'logout', =>
      @signOut()

    $ -> Authentication.checkCurrent()

  module.exports = User
