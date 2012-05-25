define (require, exports, module) ->
  routes = []

  # Redirect if we end up here from an escaped_fragment URL.
  # Breaks the back button!
  # currentLocation = location.toString()
  # if currentLocation.indexOf '?_escaped_fragment_='
  #   location.href = currentLocation.replace '?_escaped_fragment_=', '#!'

  checkRoutes = ->
    hash = location.hash.slice 2 # Slice off "#!"

    for route in routes
      params = route.match hash
      route.handler params... if params

  class Route
    path: ''
    handler: null
    expression: null

    disabled: false

    constructor: (@path, @handler) ->
      @expression = new RegExp '^' + @path.split(/\:[^\/]+/g).join '([^\\/]+)'

      routes.push @

      routes.sort (a, b) ->
        a.path.split('/').length > b.path.split('/').length

    match: (hash) =>
      return false if @disabled

      matches = @expression.exec hash

      return false unless matches

      matches.slice 1

    destroy: =>
      routes.splice i, 1 for route, i in routes when route is @

    @routes: routes

    @checkRoutes: checkRoutes

    @activate: =>
      addEventListener? 'hashchange', checkRoutes, false
      attachEvent? 'onhashchange', checkRoutes

    @deactivate: =>
      removeEventListener? 'hashchange', checkRoutes, false
      detachEvent? 'onhashchange', checkRoutes

  addEventListener? 'load', checkRoutes
  attachEvent? 'onload', checkRoutes
  Route.activate()

  exports = Route
