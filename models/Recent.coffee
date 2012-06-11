define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Subject = require './Subject'

  class Recent extends Spine.Model
    # Has many subjects
    @configure 'Recent', 'createdAt', 'subjects'

    @fromJSON: (raw) ->
      for subject in raw.subjects
        subject.workflow_ids = [raw.workflow_id]

      @create
        createdAt: raw.created_at
        subjects: (Subject.fromJSON subject for subject in raw.subjects)

    constructor: ->
      super
      @createdAt ?= new Date

    toJSON: =>
      recent:
        subject_ids: (subject.id for subject in @subjects)

  module.exports = Recent
