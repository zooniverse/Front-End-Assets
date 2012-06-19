$ = parent.jQuery

apiHost = 'https://api.zooniverse.org'
apiHost = "//#{location.hostname}:3000" unless +location.port is 80

# Check message origins against these for development.
localHosts = [
  ///^https?://localhost:\d+$///
  ///^https?://0.0.0.0:\d+$///
]

# Check message origins against these for production.
# Keep this up-to-date.
validMessageOrigins = [
  'http://www.seafloorexplorer.org:80'
]

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
  parent.postMessage data, "#{location.protocol}//#{location.host}"

# Respond to messages from the parent window (if it's a valid origin).
# They should be in the format "{COMMAND: {PARAMS}}"
$(window).on 'message', ({originalEvent: e}) ->
  isValid = e.origin in validMessageOrigins
  isLocal = (true for re in localHosts when re.test e.origin).length > 0
  unless isValid or isLocal
    throw new Error 'Invalid message origin'
    return

  data = JSON.parse e.data
  issueCommand command, params for command, params of data

# Start by seeing if anybody's logged in already.
issueCommand 'current_user', {}, postAs: 'login', ignoreFailure: true
