define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  config = require 'zooniverse/config'

  Annotation = require './Annotation'

  class Classification extends Spine.Model
    # Has a list of subjects and many annotations
    @configure 'Classification', 'workflow', 'subjects', 'annotations'

    constructor: ->
      super
      throw new Error 'Classification created without subjects' unless @subjects?

      @annotations ?= []
      new Annotation classification: @, value: clientCreated: (new Date).toUTCString()
      new Annotation classification: @, value: userAgent: navigator.userAgent

    persist: =>
      @trigger 'persisting'

      url = """
        #{config.apiHost}
        /projects/#{@workflow.project.id}
        /workflows/#{@workflow.id}
        /classifications
      """.replace /\n/g, ''

      request = $.post url, @toJSON()
      request.done => @trigger 'persist', @
      request.fail => @trigger 'error', @
      request

    toJSON: =>
      classification:
        subject_ids: (subject.id for subject in @subjects)
        annotations: (annotation.toJSON() for annotation in @annotations)

    destroy: =>
      # Copy the list first, since destroying an annotations removes it automatically.
      annotations = (annotation for annotation in @annotations)
      annotation.destroy() for annotation in annotations
      super

  module.exports = Classification
