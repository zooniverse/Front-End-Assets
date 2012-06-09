define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jquery'

  class Authentication extends Spine.Module
    @extend Spine.Events

    @iframe = $('<iframe src=""></iframe>')
    @iframe.css display: 'none'
    @iframe.appendTo 'body'

    @external = null # The iframe's window

    @setSrc: (url) =>
      @iframe.attr 'src', url
      @external = @iframe.get(0).contentWindow # Do we need to wait for load?

    @post = (message) =>
      message = JSON.stringify message
      @external.postMessage message, "#{location.protocol}//#{location.host}"

    @logIn: (username, password) =>
      @post login: {username, password}

    @logOut: =>
      @post logout: {}

    # Event data comes as {command: '', response: {}}
    $(window).on 'message', ({originalEvent: e}) =>
      data = JSON.parse e.data
      if data.response.success is true
        @trigger data.command, data.response
      else
        @trigger 'error', data.response.message

  module.exports = Authentication
