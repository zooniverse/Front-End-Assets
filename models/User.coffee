define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'
  base64 = require 'base64'

  {remove} = require 'zooniverse/util'

  API = require 'zooniverse/API'

  class User extends Spine.Module
    @extend Spine.Events
    @include Spine.Events

    @project: 'PROJECT_NOT_SPECIFIED'
    @current: null

    @fromJSON: (raw) =>
      new @
        id: raw.id
        zooniverseID: raw.zooniverse_id
        apiKey: raw.api_key
        name: raw.name
        tutorialDone: raw.project?.tutorial_done || false

    @checkCurrent: (@project) =>
      API.checkCurrent {@project}, (response) =>
        @signIn @fromJSON response if response.success

    @authenticate: ({username, password}) =>
      result = new $.Deferred

      API.logIn {@project, username, password}, (response) =>
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
        delete API.Proxy.headers['Authorization']
        @signOut()

    @signOut: =>
      @current?.destroy()
      @signIn null

    zooniverseID: ''
    name: ''
    apiKey: ''
    tutorialDone: ''

    favorites: null
    recents: null

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

      @favorites ?= []
      @recents ?= []

      # Set HTTP authentication headers for this user.
      auth = base64.encode "#{@name}:#{@apiKey}"
      API.Proxy.headers['Authorization'] = "Basic #{auth}"

    add: (map) =>
      # E.g. User.current?.add favorite: someFavorite
      for own name, thing of map
        @["#{name}s"]?.push thing
        @trigger "add-#{name}", thing
        @constructor.trigger "add-#{name}", @, thing
      @trigger 'change'
      @constructor.trigger 'change', @

    remove: (map) =>
      for own name, thing of map
        remove thing, from: @["#{name}s"]
        @trigger "remove-#{name}", thing
        @constructor.trigger "remove-#{name}", @, thing
      @trigger 'change'
      @constructor.trigger 'change', @

  module.exports = User
