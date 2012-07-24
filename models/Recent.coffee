define (require, exports, module) ->
  Base = require 'zooniverse/Base'
  Subject = require 'zooniverse/models/Subject'
  User = require 'zooniverse/models/User'
  Workflow = require 'zooniverse/Workflow'

  # NOTE: This is extended by the Favorite model. Keep it flexible.
  class Recent extends Base
    @deserialize: (raw) ->
      new @
        id: raw.id
        createdAt: raw.created_at
        subjects: (Subject.deserialize subject for subject in raw.subjects)

    @refresh: (workflow = Workflow.instances[0]) ->
      @instances ?= []
      @instances[0].destroy() while @instances.length > 0

      return unless User.current?

      fetch = workflow.api["fetch#{@name}s"] user: User.current

      fetch.done (response) =>
        for raw in response
          instance = @deserialize raw
          instance.workflow = workflow

      fetch.promise()

    id: ''
    createdAt: null
    subjects: null
    workflow: null

    constructor: ->
      super
      @createdAt ?= new Date
      @subjects ?= []
      @workflow ?= Workflow.instances[0]

      User.current?.add @constructor.name.toLowerCase(), @

    talkHREF: =>
      "http://talk.#{@workflow.domain}/objects/#{@subjects[0].zooniverseID}"

    destroy: =>
      User.current?.remove @constructor.name.toLowerCase(), @
      super

  module.exports = Recent
