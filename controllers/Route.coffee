define (require, exports, module) ->
  $ = require 'jQuery'

  {delay} = require 'zooniverse/util'

  class Route
    @routes: []

    @checkRoutes: =>
      hash = location.hash.slice 2 # Slice off "#!"

      for route in @routes
        params = route.match hash
        route.handler params... if params

    path: ''
    handler: null
    expression: null

    disabled: false

    constructor: (@path, @handler) ->
      @expression = new RegExp '^' + @path.split(/\:[^\/]+/g).join '([^\\/]+)'

      @constructor.routes.push @

      @constructor.routes.sort (a, b) ->
        a.path.split('/').length > b.path.split('/').length

    match: (hash) =>
      return false if @disabled

      matches = @expression.exec hash

      return false unless matches

      matches.slice 1

    destroy: =>
      @constructor.routes.splice i, 1 for route, i in routes when route is @

    $(window).on 'hashchange', @checkRoutes
    $.ready => delay 333, @checkRoutes # TODO: Why do we need this big delay now?

  exports = Route
