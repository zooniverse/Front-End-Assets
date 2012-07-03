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
          @postMessage message for message in @readyQueue

    # Headers to send along with requests (e.g. for authentication)
    @headers: {}

    @request: (type, url, data, done, fail) =>
      if typeof data is 'function'
        fail = done
        done = data
        data = null

      id = Math.floor Math.random() * 99999999
      @requests[id] = new $.Deferred -> @then done, fail

      message = {id, type, url, data, @headers}

      if @ready
        @postMessage message
      else
        @readyQueue.push message

      # Cleanup once it's run
      @requests[id].always => delete @requests[id]

      @requests[id]

    @getJSON: => @request 'getJSON', arguments...
    @get: => @request 'get', arguments...
    @post: => @request 'post', arguments...
    @delete: => @request 'delete', arguments...

    @postMessage: (message) =>
      @external.postMessage JSON.stringify(message), config.proxyHost

    $(window).on 'message', ({originalEvent: e}) =>
      return unless e.origin is config.proxyHost
      # Data will come back as:
      # {"id": "1234567890", "response": ["foo", "bar"]}
      {id, failure, response} = JSON.parse e.data
      @requests[id][not failure and 'resolve' or 'reject'] response

  module.exports = API
