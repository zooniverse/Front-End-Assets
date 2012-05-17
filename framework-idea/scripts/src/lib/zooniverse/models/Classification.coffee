define (require, exports, module) ->
  Spine = require 'Spine'

  class Classification extends Spine.Model
    @configure 'Classification'

    @host: 'HOST'
    @project: 'PROJECT_ID'
    @workflow: 'WORKFLOW_ID'

    @toJSON: =>
      # Override this.
      super

    persist: =>
      @trigger 'persisting'

      {host, project, workflow} = @constructor
      url = "#{host}/projects/#{project}/workflows/#{workflow}/classifications"

      request = $.post url, @toJSON()
      request.done => @trigger 'persist'
      request.fail => @trigger 'error'

      request

  module.exports = Classification
