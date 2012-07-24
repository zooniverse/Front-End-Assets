define (require, exports, module) ->
  {remove} = require 'zooniverse/util'

  class Base
    @_unique:
      subclasses: []

    @instances: null
    @_events: null

    # CoffeeScript classes normally copy object references to extended classes.
    # This will ensure that each class has its own properties.
    # TODO: This needs testing.
    @ensureUnique: (type, property) ->
      i = (i for c, i in @_unique.subclasses when c is @)[0]
      i ?= @_unique.subclasses.push(@) - 1
      @_unique[property] ?= []
      @_unique[property][i] ?= new type
      @[property] = @_unique[property][i]

    @on: (topic, callback) ->
      @ensureUnique Object, '_events'
      @_events[topic] ?= []
      @_events[topic].push callback

    @off: (topic, callback) ->
      @ensureUnique Object, '_events'
      # TODO

    @trigger: (topic, args...) ->
      @ensureUnique Object, '_events'
      @_events?[topic] ?= []
      callback.call @, args... for callback in @_events?[topic]

    # Instance

    _events: null

    constructor: (properties = {}) ->
      @constructor.ensureUnique Array, 'instances'

      @constructor.instances.push @
      @_events ?= {}

      # Mixin pased properties.
      @[property] = value for property, value of properties

    on: (topic, callback) =>
      @_events[topic] ?= []
      @_events[topic].push callback

    off: (topic, callback) =>
      # TODO

    trigger: (topic, args...) =>
      @_events[topic] ?= []
      callback.call @, args... for callback in @_events[topic]
      @constructor.trigger? topic, @, args...

    destroy: =>
      @trigger 'destroy', arguments...
      @off()
      remove @, from: @constructor.instances

  module.exports = Base
