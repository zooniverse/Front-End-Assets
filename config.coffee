define (require, exports, module) ->
  config =
    dev: +location.port > 1023 or !!~location.hostname.indexOf '.dev'
    host: 'https://api.zooniverse.org'
    authHost: 'https://zooniverse-login.s3.amazonaws.com'
    authPath: '/login.html'

  # Shortcut for setting a bunch of options
  config.set = (options) ->
    for own key, value of options
      throw new Error 'Don\'t overwrite "set" in config.' if key is 'set'
      config[key] = value

  if config.dev
    config.set
      host: "http://#{location.hostname}:3000"
      authHost: "http://#{location.host}"
      authPath: '/src/scripts/lib/zooniverse/login-frame/login.html'

  module.exports = config
