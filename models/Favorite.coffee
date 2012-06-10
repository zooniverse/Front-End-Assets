define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Subject = require './Subject'

  class Favorite extends Spine.Model
    # Has many subjects
    @configure 'Favorite', 'createdAt', 'subjects'

    @fromJSON: (raw) ->
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

      project = @subjects[0].workflow.project
      url = "#{project.app.host}/projects/#{project.id}/favorites"
      post = $.post url, @toJSON()
      post.done => @trigger 'persist'
      post.fail => @trigger 'error'

  module.exports = Favorite
