define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  class Classification extends Spine.Model
    @configure 'Classification'

    @workflow: null

    @toJSON: =>
      # Override this.
      super

    persist: =>
      @trigger 'persisting'

      workflow = @constructor.workflow
      project = workflow.project()
      url = "#{project.host}/projects/#{project.id}/workflows/#{workflow.id}/classifications"

      request = $.post url, @toJSON()
      request.done => @trigger 'persist'
      request.fail => @trigger 'error'

      request

  module.exports = Classification
