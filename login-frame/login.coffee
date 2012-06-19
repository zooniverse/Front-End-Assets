$ = window.jQuery

apiHost = 'https://api.zooniverse.org'
apiHost = "//#{location.hostname}:3000" unless +location.port < 1024

# Check message origins against these for development.
localHosts = [
  ///^https?://localhost:?\d*$///
  ///^https?://0.0.0.0:?\d*$///
]

# Check message origins against these for production.
# Keep this up-to-date.
validMessageOrigins = [
  'http://www.seafloorexplorer.org'
]

# This is the parent's origin, set when we recieve a message from it.
recipient = ''

# Make a request from the frame to the API host.
issueCommand = (command, params = {}, options = {}) ->
  request = $.getJSON "#{apiHost}/#{command}?callback=?", params

  request.done (response) ->
    postBack options.postAs || command, response

  request.fail (response) ->
    return if options.ignoreFailure
    postBack command, success: false, message: 'Couldn\'t connect to the server'

# Post a message from the frame to the parent window.
postBack = (command, response) ->
  data = JSON.stringify {command, response}
  parent.postMessage data, recipient

# Respond to messages from the parent window (if it's a valid origin).
# They should be in the format "{COMMAND: {PARAMS}}"
$(window).on 'message', ({originalEvent: e}) ->
  isValid = e.origin in validMessageOrigins
  isLocal = (true for re in localHosts when re.test e.origin).length > 0
  unless isValid or isLocal
    throw new Error 'Invalid message origin'
    return

  recipient = e.origin
  data = JSON.parse e.data

  if 'current_user' of data
    issueCommand 'current_user', {}, postAs: 'login', ignoreFailure: true
    return

  issueCommand command, params for command, params of data
