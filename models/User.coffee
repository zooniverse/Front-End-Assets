define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'
  base64 = require 'base64'

  API = require 'zooniverse/API'
  config = require 'zooniverse/config'
  {remove} = require 'zooniverse/util'

  Favorite = require './Favorite'
  Recent = require './Recent'

  class User extends Spine.Model
    @configure 'User', 'zooniverseId', 'name', 'apiKey', 'tutorialDone', 'favorites', 'recents'

    @project: 'PROJECT_NOT_SPECIFIED'
    @current: null

    @fromJSON: (raw) ->
      super
        id: raw.id
        zooniverseId: raw.zooniverse_id
        apiKey: raw.api_key
        name: raw.name
        tutorialDone: raw.project?.tutorial_done || false

    @checkCurrent: (@project) =>
      API.getJSON "/projects/#{@project.id}/current_user", (response) =>
        @signIn @fromJSON response if response.success

    @authenticate: ({username, password}) =>
      result = new $.Deferred

      API.getJSON "/projects/#{@project.id}/login", {username, password}, (response) =>
        if response.success
          @signIn @fromJSON response
          result.resolve @current
        else
          @trigger 'authentication-error', response.message
          result.reject response.message

      result.promise()

    @signIn: (user) =>
      # Always sign out, but only sign in if the user has changed.
      return if user is @current unless @current is null
      @current = user

      @trigger 'sign-in', @current

    @deauthenticate: =>
      API.getJSON "/projects/#{@project.id}/logout", =>
        delete API.headers['Authorization']
        @signOut()

    @signOut: =>
      @current?.destroy()
      @signIn null

    constructor: ->
      super
      @favorites ?= []
      @recents ?= []

      # Set HTTP authentication headers for this user.
      auth = base64.encode "#{@name}:#{@apiKey}"
      API.headers['Authorization'] = "Basic #{auth}"

      Favorite.bind 'create', @onCreateFavorite
      Favorite.bind 'destroy', @onDestroyFavorite
      Recent.bind 'create', @onCreateRecent
      Recent.bind 'destroy', @onDestroyRecent

      @refreshFavorites()
      @refreshRecents()

    refreshSomething: (attribute, model) =>
      refresh = new $.Deferred

      API.get "/projects/#{@constructor.project.id}/users/#{@id}/#{attribute}", (response) =>
        model.fromJSON raw for raw in response.reverse()
        @trigger "refresh-#{attribute}"
        @trigger "change"

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

    destroy: =>
      @favorites[0].destroy() while @favorites.length > 0
      @recents[0].destroy() while @recents.length > 0
      super

  module.exports = User
