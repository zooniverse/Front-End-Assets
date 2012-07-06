define (require, exports, module) ->
  Spine = require 'Spine'

  class Project extends Spine.Model
    @configure 'Project', 'app', 'workflows'

    constructor: ->
      super

      @workflows ?= []
      @workflows = [@workflows] unless @workflows instanceof Array
      workflow.project = @ for workflow in @workflows

  module.exports = Project
