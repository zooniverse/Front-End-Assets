define (require, exports, module) ->
  config =
    dev: +location.port > 1023 or !!~location.hostname.indexOf '.dev'
    host: 'https://api.zooniverse.org'
    authentication: "https://zooniverse-login.s3.amazonaws.com/login.html"

  if config.dev
    config.host = "//#{location.hostname}:3000"
    config.authentication = "//#{location.host}/src/scripts/lib/zooniverse/login-frame/login.html"

  # Shortcut for setting a bunch of options
  config.set = (options) ->
    for own key, value of options
      throw new Error 'Don\'t overwrite "set" in config.' if key is 'set'
      config[key] = value

  window.config = config if config.dev
  module.exports = config
