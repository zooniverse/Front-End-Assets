define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Authentication = require 'zooniverse/controllers/Authentication'

  Favorite = require 'zooniverse/models/Favorite'
  Recent = require 'zooniverse/models/Recent'
  Group = require 'zooniverse/models/Group'

  class User extends Spine.Model
    @configure 'User', 'zooniverseId', 'name', 'apiKey', 'finishedTutorial'
    @hasMany 'favorites', Favorite
    @hasMany 'recents', Recent
    @hasMany 'groups', Group

    @fromJSON: (raw) ->
      super
        id: raw.id
        zooniverseId: raw.zooniverse_id
        name: raw.name
        apiKey: raw.api_key

    @current: null

    @signIn: (user) =>
      return if user is @current
      @current = user
      @trigger 'sign-in', @current

    @signOut: =>
      @current?.destroy()
      @signIn null

    Authentication.bind 'login', (data) =>
      @signIn @fromJSON data

    Authentication.bind 'logout', =>
      @signOut()

  module.exports = User
