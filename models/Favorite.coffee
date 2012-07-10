define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  API = require 'zooniverse/API'

  Subject = require './Subject'

  class Favorite extends Spine.Model
    @configure 'Favorite', 'createdAt', 'subjects'

    @fromJSON: (raw) ->
      for subject in raw.subjects
        subject.workflow_ids = [raw.workflow_id]

      @create
        id: raw.id
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

      path = "/projects/#{@subjects[0].workflow.project.id}/favorites"
      post = API.post path, @toJSON()

      post.done (response) =>
        @id = response.id
        @trigger 'persist'

      post.fail (response) =>
        @trigger 'error', response

    destroy: (fromServer) =>
      super
      path = "/projects/#{@subjects[0].workflow.project.id}/favorites/#{@id}"
      API.delete path if fromServer is true

  module.exports = Favorite
