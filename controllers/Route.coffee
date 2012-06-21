define (require, exports, module) ->
  $ = require 'jQuery'
  {remove} = require 'zooniverse/util'

  class Route
    @routes: []
    @lastCheckedHash = ''
    @checkHash: (hash) =>
      # Slice off "#!" from the hash.
      hash = location.hash.slice 2 unless typeof hash is 'string'

      for route in @routes
        params = route.test hash
        route.handler params... if params?

      @lastCheckedHash = hash

    path: '' # Like "/foo/:bar"
    handler: null

    constructor: (@path, @handler) ->
      @constructor.routes.push @

      # Sort by number of segments so more generic routes fire before more specific ones.
      @constructor.routes.sort (a, b) ->
        a.path.split('/').length > b.path.split('/').length

    test: (hash) =>
      pathSegments = @path.split '/'
      hashSegments = hash.split '/'

      # The hash must be as long or longer than the path.
      return if pathSegments.length > hashSegments.length

      params = []
      for pathSegment, i in pathSegments
        if pathSegment.charAt(0) is ':'
          params.push hashSegments[i]
        else if hashSegments[i] in [pathSegments[i], '...']
          continue
        else
          return

      params

    destroy: =>
      remove @, from: @constructor.routes

    $(window).on 'hashchange', @checkHash
    $ => @checkHash()

  exports = Route
