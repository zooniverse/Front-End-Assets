define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  API = require 'zooniverse/API'

  Subject = require 'zooniverse/models/Subject'

  class Favorite extends Spine.Model
    @configure 'Favorite', 'createdAt', 'projectID', 'subjects'

    @fromJSON: (raw) ->
      @create
        id: raw.id
        createdAt: raw.created_at
        projectID: raw.project_id
        subjects: (Subject.fromJSON subject for subject in raw.subjects)

    constructor: ->
      super
      @createdAt ?= new Date

    toJSON: =>
      favorite:
        subject_ids: (subject.id for subject in @subjects)

    persist: =>
      @trigger 'persisting'

      path = "/projects/#{@projectID}/favorites"
      post = API.post path, @toJSON()

      post.done (response) =>
        @id = response.id
        @trigger 'persist'

      post.fail (response) =>
        @trigger 'error', response

    destroy: (fromServer) =>
      super
      path = "/projects/#{@projectID}/favorites/#{@id}"
      API.delete path if fromServer is true

  module.exports = Favorite
