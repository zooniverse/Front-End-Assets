define (require, exports, module) ->
  Base = require 'zooniverse/Base'
  {remove} = require 'zooniverse/util'

  class Annotation extends Base
    value: null

    constructor: ->
      super
      @value ?= {}

      @on 'change', =>
        @classification.trigger 'change', @, arguments...

    set: (valueMap) =>
      @value[key] = value for key, value of valueMap
      @trigger 'change', valueMap

    get: (key) =>
      @value[key]

    serialize: =>
      @value

    destroy: =>
      remove @, from: @classification.annotations
      @classification.trigger 'change'
      super

  module.exports = Annotation
