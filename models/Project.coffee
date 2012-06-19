define (require, exports, module) ->
  Spine = require 'Spine'

  class Project extends Spine.Model
    @configure 'Project', 'devID', 'app', 'workflows'

    constructor: ->
      super

      @id = @devID if config.dev

      @workflows ?= []
      workflow.project = @ for workflow in @workflows

  module.exports = Project
