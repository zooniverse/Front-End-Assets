define (require, exports, module) ->
  Spine = require 'spine'
  $ = require 'jquery'
  {delay} = require 'zooniverse/util'

  # Redirect if we end up here from an escaped_fragment URL.
  # Breaks the back button!
  # currentLocation = location.toString()
  # if currentLocation.indexOf '?_escaped_fragment_='
  #   location.href = currentLocation.replace '?_escaped_fragment_=', '#!'

  class Route extends Spine.Module
    @extend Spine.Events
    @include Spine.Events

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

    $ => delay @checkRoutes
    $(window).on 'hashchange', @checkRoutes

  exports = Route
