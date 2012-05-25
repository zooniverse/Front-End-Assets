define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Project = require 'zooniverse/models/Project'

  class Classification extends Spine.Model
    @configure 'Classification'

    @workflow: null

    @toJSON: =>
      # Override this.
      super

    persist: =>
      @trigger 'persisting'

      url = "#{Project.current.host}/projects/#{Project.current.id}/workflows/#{@constructor.workflow.id}/classifications"

      request = $.post url, @toJSON()
      request.done => @trigger 'persist'
      request.fail => @trigger 'error'

      request

  module.exports = Classification
