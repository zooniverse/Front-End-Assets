# The parent's jQuery will only work in dev
# and is only here in case you lose the CDN.
$ = window.jQuery || parent.jQuery
$.support.cors = true

# Notify any parent that the authentication iframe is ready.
readyMessage = id: 'READY', response: success: true
$ -> parent.postMessage JSON.stringify(readyMessage), '*'

apiHost = ''
apiHost = "//#{location.hostname}:3000" unless +location.port < 1024

# Check message origins against these for development.
localHosts = [
  ///^https?://localhost:?\d*$///
  ///^https?://hosthost:?\d*$/// # Brian maps this to 10.0.2.2 in VMs.
  ///^https?://\w+\.dev:?\d*$/// # Pow
  ///^https?://0.0.0.0:?\d*$///
  ///^file:///
]

# Check message origins against these for production.
# Keep this up-to-date.
validMessageOrigins = [
  'http://www.seafloorexplorer.org'
]

# This is the parent's origin, set when we recieve a message from it.
recipient = ''

# Respond to messages from the parent window.
$(window).on 'message', ({originalEvent: e}) ->
  isValid = e.origin in validMessageOrigins
  isLocal = (true for re in localHosts when re.test e.origin).length > 0
  if isValid or isLocal
    recipient = e.origin
  else
    throw new Error 'Invalid message origin'

  {id, method, url, options} = JSON.parse e.data
  url = "#{url}?callback=?" if method is 'getJSON' and not ~url.indexOf 'callback'

  request = $[method] "#{apiHost}#{url}", options

  request.done (response) ->
    parent.postMessage JSON.stringify({id, response}), recipient

  request.fail (response) ->
    parent.postMessage JSON.stringify({id, failure: true, response}), recipient
