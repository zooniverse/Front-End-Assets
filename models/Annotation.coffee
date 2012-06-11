define (require, exports, module) ->
  Spine = require 'Spine'

  class Annotation extends Spine.Model
    # Belongs to a classification
    @configure 'Annotation', 'value', 'classification'

    constructor: ->
      super
      @value ?= {}

      throw new Error 'Annotation created without a classification' unless @classification?

      @bind 'change', =>
        @classification.trigger 'change'

      alreadyThere = false
      # NOTE: Spine seems to be running model constructors twice. Bug?
      for annotation in @classification.annotations
        alreadyThere ||= annotation.eql @

      @classification.annotations.push @ unless alreadyThere
      @classification.trigger 'change'

    toJSON: =>
      @value

    destroy: =>
      for annotation, i in @classification.annotations when annotation is @
        @classification.annotations.splice i, 1

      @classification.trigger 'change'

      super

  module.exports = Annotation
