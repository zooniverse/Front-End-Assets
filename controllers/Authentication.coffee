define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

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
      @external.postMessage message, "#{location.protocol}//#{location.host}"

    @logIn: (username, password) =>
      @post login: {username, password}

    @logOut: =>
      @post logout: {}

    # Event data comes as {command: '', response: {}}
    $(window).on 'message', ({originalEvent: e}) =>
      # console.info 'Message from auth', e
      if e.data.response.success is true
        @trigger e.data.command, e.data.response
      else
        @trigger 'error', e.data.response.message

  module.exports = Authentication
