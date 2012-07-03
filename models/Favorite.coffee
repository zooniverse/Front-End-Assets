define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  API = require 'zooniverse/API'
  config = require 'zooniverse/config'

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

      url = "/projects/#{config.app.projects[0].id}/favorites"
      post = API.post url, @toJSON()

      post.done (response) =>
        response = JSON.parse response
        @id = response.id
        @trigger 'persist'

      post.fail => @trigger 'error'

    destroy: =>
      super
      API.delete "/projects/#{config.app.projects[0].id}/favorites/#{@id}"

  module.exports = Favorite
