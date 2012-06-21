define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  {delay} = require 'zooniverse/util'
  config = require 'zooniverse/config'
  authLink = $("<a href='#{config.authentication}'></a>").get(0)
  authOrigin = "#{authLink.protocol}//#{authLink.host}"

  class Authentication extends Spine.Module
    @extend Spine.Events

    @iframe = $("<iframe src='#{config.authentication}'></iframe>")
    @iframe.css display: 'none'
    @iframe.appendTo 'body'
    @external = @iframe.get(0).contentWindow # Do we need to wait for load?

    @post = (message) =>
      message = JSON.stringify message
      @external.postMessage message, authOrigin

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
        @checkCurrent()
        return

      data = JSON.parse e.data

      if data.response.success is true
        @trigger data.command, data.response
      else
        @trigger 'error', data.response.message unless data.command is 'current_user'

  module.exports = Authentication
