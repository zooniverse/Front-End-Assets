# The parent's jQuery will only work in dev
# and is only here in case you lose the CDN.
$ = window.jQuery || parent.jQuery
$.support.cors = true

# Notify any parent that the authentication iframe is ready.
readyMessage = id: 'READY', response: success: true
$ -> parent.postMessage JSON.stringify(readyMessage), '*'

apiHost = '' # Same origin
apiHost = "//#{location.hostname}:3000" unless +location.port < 1024

# Check message origins against these for development.
localHosts = [
  ///^https?://localhost:?\d*$///
  ///^https?://0.0.0.0:?\d*$///
  ///^file:///
  ///^https?://hosthost:?\d*$/// # Brian maps this to 10.0.2.2 in VMs.
  ///^https?://\w+\.dev:?\d*$/// # Pow (or any other *.dev alias)
]

# Check message origins against these for production.
# Keep this up-to-date.
validMessageOrigins = [
  'http://www.batdetective.org'
  'http://www.seafloorexplorer.org'
]

# This is the parent's origin, set when we recieve a message from it.
recipient = ''

# Respond to messages from the parent window.
$(window).on 'message', ({originalEvent: e}) ->
  isValid = e.origin in validMessageOrigins
  isLocal = (true for re in localHosts when re.test e.origin).length > 0
  throw new Error 'Invalid message origin' unless isValid or isLocal

  recipient = e.origin

  {id, type, url, data, headers} = JSON.parse e.data

  url = "#{apiHost}#{url}"
  dataType = 'json'

  if type is 'getJSON'
    type = 'GET'
    dataType = 'jsonp'

  beforeSend = (xhr) =>
    xhr.setRequestHeader header, value for header, value of headers

  request = $.ajax {type, beforeSend, url, data, dataType}

  request.done (response) ->
    parent.postMessage JSON.stringify({id, response}), recipient

  request.fail (response) ->
    parent.postMessage JSON.stringify({id, response, failure: true}), recipient
