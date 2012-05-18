define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Authentication = require 'zooniverse/controllers/Authentication'

  class User extends Spine.Model
    @configure 'User', 'zooniverseId', 'name', 'apiKey', 'finishedTutorial'

    @fromJSON: (raw) ->
      super
        id: raw.id
        zooniverseId: raw.zooniverse_id
        name: raw.name
        apiKey: raw.api_key

    @current: null

    @signIn: (user) ->
      return if user is @current
      @current = user
      @trigger 'sign-in', @current

    @signOut: ->
      @current?.destroy()
      @signIn null

    Authentication.bind 'login', (data) ->
      User.signIn User.fromJSON(data)

    Authentication.bind 'logout', ->
      User.signOut()

  window.User = User
  module.exports = User
