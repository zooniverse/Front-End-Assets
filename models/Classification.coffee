define (require, exports, module) ->
  Base = require 'zooniverse/Base'
  Annotation = require 'zooniverse/models/Annotation'

  class Classification extends Base
    annotations: null
    zoo: null

    constructor: ->
      super

      @annotations ?= []
      @annotate clientCreated: (new Date).toUTCString()
      @annotate userAgent: navigator.userAgent

    annotate: (value) =>
      @annotations.push new Annotation
        classification: @
        value: value
      @annotations[-1...][0]

    persist: =>
      @trigger 'persisting'
      request = @zoo.api.saveClassification @serialize(), => @trigger 'persist', @

    serialize: =>
      subjects: (subject for subject in @subjects)
      annotations: (annotation.serialize() for annotation in @annotations)

    destroy: =>
      @annotations[0].destroy() until @annotations.length is 0
      super

  module.exports = Classification
