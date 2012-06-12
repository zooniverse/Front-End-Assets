define (require, exports, module) ->
  Spine = require 'Spine'

  class Project extends Spine.Model
    @configure 'Project', 'app', 'workflows'

    constructor: ->
      super

      @workflows ?= []
      workflow.project = @ for workflow in @workflows

  module.exports = Project
