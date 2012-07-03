define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  {remove} = require 'zooniverse/util'

  class API extends Spine.Module
    @extend Spine.Events

    @ready: false # Iframe will post "ready" signal when it loads.

    @iframe = $("<iframe src='#{config.proxyHost}#{config.proxyPath}'></iframe>")
    @iframe.css display: 'none'
    @iframe.appendTo 'body'
    @external = @iframe.get(0).contentWindow

    # Requests added here and posted when the iframe is ready.
    @readyQueue: []

    @requests:
      # The iframe will post a "READY" message when it loads.
      READY: new $.Deferred (deferred) =>
        deferred.done =>
          @ready = true
          @post message for message in @readyQueue

    @request: (method, url, options..., done, fail) =>
      id = Math.floor Math.random() * 99999999
      @requests[id] = new $.Deferred -> @then done, fail

      message = {id, method, url, options: options[0]}

      if @ready
        @post message
      else
        @readyQueue.push message

      # Cleanup once it's run
      @requests[id].always => delete @requests[id]

      @requests[id]

    @getJSON: => @request 'getJSON', arguments...
    @get: => @request 'get', arguments...
    @post: => @request 'post', arguments...
    @delete: => @request 'delete', arguments...

    @post: (message) =>
      @external.postMessage JSON.stringify(message), config.proxyHost

    $(window).on 'message', ({originalEvent: e}) =>
      return unless e.origin is config.proxyHost
      # Data will come back as:
      # {"id": "1234567890", "response": ["foo", "bar"]}
      {id, failure, response} = JSON.parse e.data
      @requests[id][not failure and 'resolve' or 'reject'] response

  module.exports = API
