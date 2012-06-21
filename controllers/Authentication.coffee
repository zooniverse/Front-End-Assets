define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  {delay} = require 'zooniverse/util'
  config = require 'zooniverse/config'

  class Authentication extends Spine.Module
    @extend Spine.Events

    @iframe = $("<iframe src='#{config.authHost}#{config.authPath}'></iframe>")
    @iframe.css display: 'none'
    @iframe.appendTo 'body'
    @external = @iframe.get(0).contentWindow # Do we need to wait for load?

    @post = (message) =>
      message = JSON.stringify message
      console.log "Auth origin is #{config.authHost}"
      @external.postMessage message, config.authHost

    @logIn: (username, password) =>
      @post login: {username, password}

    @logOut: =>
      @post logout: {}

    @checkCurrent: =>
      @post current_user: {}

    # Event data comes as {command: '', response: {}}
    $(window).on 'message', ({originalEvent: e}) =>
      # Initial ready notification from the iframe
      if e.data is 'READY'
        console.log 'Auth frame ready, checking current user'
        @checkCurrent()
        return

      data = JSON.parse e.data

      if data.response.success is true
        @trigger data.command, data.response
      else
        @trigger 'error', data.response.message unless data.command is 'current_user'

  module.exports = Authentication
