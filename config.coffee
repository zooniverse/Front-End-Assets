define (require, exports, module) ->
  # This object stores generic information about the app that might need to be available globally.
  config = {}

  # `set` is a shortcut for setting a bunch of properties by passing in an object.
  config.set = (options) ->
    for own key, value of options
      throw new Error 'Don\'t overwrite "set" in config.' if key is 'set'
      config[key] = value

  # Determine if we're running on a development server.
  config.set dev: +location.port > 1023 or !!~location.hostname.indexOf '.dev'

  # We can assume some hosts if we're on a dev server.
  if config.dev
    config.set
      apiHost: "http://#{location.hostname}:3000" # TODO: What if Ouroboros isn't on 3000?
      proxyHost: "http://#{location.hostname}:3000"
      proxyPath: '/proxy/index.html'
  else
    config.set
      apiHost: 'https://api.zooniverse.org'
      proxyHost: 'https://api.zooniverse.org'
      proxyPath: '/proxy/index.html'

  module.exports = config
