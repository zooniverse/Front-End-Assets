define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Subject = require './Subject'
  App = require './App'

  class Favorite extends Spine.Model
    createdAt: new Date
    @configure 'Favorite', 'createdAt', 'subjects'

    @fromJSON: (raw) ->
      @create
        createdAt: raw.created_at
        subjects: (Subject.fromJSON subject for subject in raw.subjects)

    toJSON: =>
      favorite:
        subject_ids: (subject.id for subject in @subjects)

    persist: =>
      @trigger 'persisting'

      url = "#{App.first().host}/projects/#{App.first().projects[0].id}/favorites"
      post = $.post url, @toJSON()
      post.done => @trigger 'persist'
      post.fail => @trigger 'error'

  module.exports = Favorite
