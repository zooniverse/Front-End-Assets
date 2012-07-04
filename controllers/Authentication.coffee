define (require, exports, module) ->
  Spine = require 'Spine'

  config = require 'zooniverse/config'

  API = require 'zooniverse/API'

  class Authentication extends Spine.Module
    @extend Spine.Events

    @logIn: (username, password) =>
      API.getJSON '/login', {username, password}, (rawUser) =>
        @trigger 'login', rawUser if rawUser.success

    @logOut: =>
      API.getJSON '/logout', =>
        @trigger 'logout'

    @checkCurrent: =>
      API.getJSON '/current_user', (rawUser) =>
        if rawUser.success
          @trigger 'login', rawUser
        else
          @trigger 'logout'

  module.exports = Authentication
