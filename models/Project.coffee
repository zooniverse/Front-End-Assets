define (require, exports, module) ->
  Spine = require 'Spine'

  class Project extends Spine.Model
    @configure 'Project', 'name', 'slug', 'description', 'app', 'workflows'
    name: 'Zooniverse'
    slug: 'zooniverse'
    description: 'Real Science Online'

    constructor: ->
      super
      @workflows ?= []
      workflow.project = @ for workflow in @workflows

    save: =>
      super
      workflow.save() for workflow in @workflows

  module.exports = Project
