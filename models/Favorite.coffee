define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  config = require 'zooniverse/config'

  Subject = require './Subject'

  class Favorite extends Spine.Model
    @configure 'Favorite', 'createdAt', 'subjects'

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
      favorite:
        subject_ids: (subject.id for subject in @subjects)

    persist: =>
      @trigger 'persisting'

      url = "#{config.apiHost}/projects/#{config.app.projects[0].id}/favorites"
      post = $.post url, @toJSON()
      post.done => @trigger 'persist'
      post.fail => @trigger 'error'

  module.exports = Favorite
