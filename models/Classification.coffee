define (require, exports, module) ->
  Spine = require 'spine'
  $ = require 'jquery'
  Annotation = require './Annotation'

  class Classification extends Spine.Model
    # Has a list of subjects and many annotations
    @configure 'Classification', 'metadata', 'subjects', 'annotations'

    constructor: ->
      super
      @annotations ?= []
      throw new Error 'Classification created without subjects' unless @subjects?

    persist: =>
      @trigger 'persisting'

      url = """
        #{@subjects[0].workflow.project.app.host}
        /projects/#{@subjects[0].workflow.project.id}
        /workflows/#{@subjects[0].workflow.id}
        /classifications
      """.replace /\n/g, ''

      request = $.post url, @toJSON()
      request.done => @trigger 'persist', @
      request.fail => @trigger 'error', @
      request

    toJSON: =>
      $.extend
        classification:
          subject_ids: (subject.id for subject in @subjects)
          annotations: (annotation.toJSON() for annotation in @annotations)
        @metadata

    destroy: =>
      # Copy the list first, since destroying an annotations removes it automatically.
      annotations = (annotation for annotation in @annotations)
      annotation.destroy() for annotation in annotations
      super

  module.exports = Classification
