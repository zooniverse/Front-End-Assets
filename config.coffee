define (require, exports, module) ->
  config =
    dev: +location.port isnt 80 or !!~location.hostname.indexOf '.dev'
    host: 'TODO: http://some.ouroboros.server'
    authentication: "TODO: http://some.s3.bucket/path/to/auth.html"

  if config.dev
    config.host = "//#{location.hostname}:3000"
    config.authentication = "//#{location.host}/src/scripts/lib/zooniverse/login-frame/index.html"

  # Shortcut for setting a bunch of options
  config.set = (options) ->
    for own key, value of options
      throw new Error 'Don\'t overwrite "set" in config.' if key is 'set'
      config[key] = value

  window.config = config if config.dev
  module.exports = config
