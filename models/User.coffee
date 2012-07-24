define (require, exports, module) ->
  Base = require 'zooniverse/Base'
  $ = require 'jQuery'
  base64 = require 'base64'
  {remove} = require 'zooniverse/util'
  Proxy = require 'zooniverse/Proxy'

  class User extends Base
    @current: null
    @currentChecked: false

    @deserialize: (raw) =>
      new @
        id: raw.id
        zooniverseID: raw.zooniverse_id
        apiKey: raw.api_key
        name: raw.name
        tutorialDone: raw.project?.tutorial_done || false

    @checkCurrent: ({api}) =>
      console.log 'Checking current user...'
      api.checkCurrent (response) =>
        console.log 'Current user', response.name || response.success

        if response.success
          @signIn @deserialize response
        else
          @signOut()

        @currentChecked = true

    @authenticate: ({api}, {username, password}) =>
      result = new $.Deferred

      api.logIn {username, password}, (response) =>
        # TODO: What if we're already logged in?
        if response.success
          @signIn @deserialize response
          result.resolve @current
        else
          @trigger 'authentication-error', response.message
          result.reject response.message

      result.promise()

    @signIn: (user) =>
      # Always sign out, but only sign in if the user has changed.
      return if user is @current and @currentChecked
      @current = user
      @trigger 'sign-in', @current

    @deauthenticate: ({api}) =>
      api.logout =>
        delete Proxy.headers['Authorization']
        @signOut()

    @signOut: =>
      @signIn null

    zooniverseID: ''
    name: ''
    apiKey: ''
    tutorialDone: ''

    favorites: null
    recents: null

    constructor: ->
      super
      @favorites ?= []
      @recents ?= []

      # Set HTTP authentication headers for this user.
      auth = base64.encode "#{@name}:#{@apiKey}"
      Proxy.headers['Authorization'] = "Basic #{auth}"

    add: (type, thing) =>
      # E.g. User.current?.add 'favorite', someFavorite
      @["#{type}s"]?.push thing
      @trigger "add-#{type}", thing

    remove: (type, thing) =>
      remove thing, from: @["#{type}s"]
      @trigger "remove-#{type}", thing

  module.exports = User
