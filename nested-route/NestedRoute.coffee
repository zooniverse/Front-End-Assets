define (require, exports) ->
	Spine = require 'Spine'

	# This totally sucks,
	# but there's no way to extend this so that the context
	# of the original methods is the extended class.
	Spine.Route.originalMatchRoute = Spine.Route.matchRoute
	Spine.Route.matchRoute = (path, options) ->
		if typeof path is 'string' then path = path.split '/'

		matchPath = []
		while path.length > 0
			matchPath.push path.shift()
			matchedPath = matchPath.join '/'

			if matchedPath then @originalMatchRoute matchedPath

	# Since we're not using history, we want to keep
	# Spine from trigering routes if there's no hash.
	Spine.Route.originalChange = Spine.Route.change
	Spine.Route.change = ->
		fragment = Spine.Route.getFragment()
		if fragment then Spine.Route.matchRoute fragment

	exports = Spine.Route
