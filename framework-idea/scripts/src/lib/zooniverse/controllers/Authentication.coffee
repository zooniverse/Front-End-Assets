define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  class Authentication extends Spine.Module
    @extend Spine.Events

    frame = null
    external = null # The iframe's window

    frame = $('<iframe src=""></iframe>')
    frame.css display: 'none'
    frame.appendTo 'body'

    post = (message) ->
      external.postMessage message, "#{location.protocol}//#{location.host}"

    @setSrc: (url) ->
      frame.attr 'src', url
      external = frame.get(0).contentWindow # Do we need to wait for load?

    @logIn: (username, password) ->
      post login: {username, password}

    @logOut: ->
      post logout: null

  handleMessage = ({originalEvent: e}) ->
    # console.info 'Message from auth', e
    if e.data.response.success is true
      Authentication.trigger e.data.command, e.data.response
    else
      Authentication.trigger 'error', e.data.response.message

  # Event data comes as {command: '', response: {}}
  $(window).on 'message', handleMessage

  module.exports = Authentication
