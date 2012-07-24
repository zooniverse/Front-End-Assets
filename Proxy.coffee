define (require, exports, module) ->
  $ = require 'jQuery'
  {remove} = require 'zooniverse/util'

  apiHost = 'https://zpi.zooniverse.org'
  apiHost = 'http://localhost:3000' if +location.port >= 1024
  proxyPath = '/proxy/index.html'

  # We'll proxy all interaction with the API through an iframe on its domain.
  frame = $("<iframe src='#{apiHost}#{proxyPath}'></iframe>")
  frame.css display: 'none'
  frame.appendTo 'body'

  # The iframe will post "ready" message when it loads.
  ready = false

  # Requests added here are posted sequentially when the iframe is ready.
  readyDaisyChain = [new $.Deferred]

  requests =
    READY: new $.Deferred (deferred) =>
      deferred.always =>
        ready = true
        # Kick off the daisy chain when the "ready" message comes.
        readyDaisyChain[0].resolve()
        remove readyDaisyChain[0], from: readyDaisyChain

  # Headers to send along with requests (e.g. for authentication)
  headers = {}

  postMessage = (message) =>
    frameWindow = frame.get(0).contentWindow
    frameWindow.postMessage JSON.stringify(message), apiHost

  request = (type, url, data, done, fail) =>
    if typeof data is 'function'
      fail = done
      done = data
      data = null

    id = Math.floor Math.random() * 99999999
    deferred = new $.Deferred (self) -> self.then done, fail

    message = {id, type, url, data, headers}

    if ready
      postMessage message
    else
      # Post this message after the last deferred in the chain has completed.
      readyDaisyChain.slice(-1)[0].always =>
        postMessage message
        remove deferred, from: readyDaisyChain

      # Add this deferred to the end of the chain.
      readyDaisyChain.push deferred

    requests[id] = deferred
    deferred.always => delete requests[id]

    deferred

  $(window).on 'message', ({originalEvent: e}) ->
    return unless e.origin is apiHost
    # Data will come back as:
    # {"id": "1234567890", "response": ["foo", "bar"]}
    {id, failure, response} = JSON.parse e.data
    requests[id][not failure and 'resolve' or 'reject'] response

  module.exports =
    get: => request 'get', arguments...
    post: => request 'post', arguments...
    del: => request 'delete', arguments...
    getJSON: => request 'getJSON', arguments...
    headers: headers
