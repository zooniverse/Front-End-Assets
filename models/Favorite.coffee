define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Project = require 'zooniverse/models/Project'
  User = require 'zooniverse/models/User'

  class Favorite extends Spine.Model
    subjects: []
    createdAt: new Date
    @configure 'Favorite', 'subjects', 'createdAt'

    @fromJSON: (raw) ->
      super
        subjects: raw.subjects
        createdAt: raw.created_at

    @fetch: =>
      return unless User.current?

      @trigger 'fetching'

      url = "#{Project.current.host}/projects/#{Project.current.id}/users/#{User.current.id}/favorites"
      request = $.getJSON url
      handle = new $.Deferred

      request.done (response) =>
        newFavorites = (@fromJSON item for item in response)
        favorite.save() for favorite in newFavorites
        handle.resolve newFavorites
        @trigger 'fetch'
        User.current.trigger 'change'

      request.fail (args...) ->
        handle.reject args...
        @trigger 'error'

      handle.promise()

    @reload: =>
      @destroyAll()
      return unless User.current?
      @fetch()

    persist: =>
      @trigger 'persisting'

      post = $.post "#{Project.current.host}/projects/#{Project.current.id}/favorites",
        favorite:
          subject_ids: (subject.id for subject in @subjects)
          subjects: (subject.toJSON() for subject in @subjects)

      post.done =>
        @trigger 'persist'
        @constructor.reload()

      post.fail =>
        @trigger 'error'

    talkHref: =>
      "#{Project.current.talkHost}/objects/#{@subjects[0].zooniverse_id}"

    facebookHref: =>
      """
        https://www.facebook.com/dialog/feed?
        app_id=#{Project.current.facebookAppId}&
        link=#{@talkHref()}&
        picture=#{@subjects[0].location || @subjects[0].image || @subjects[0].location.image}&
        name=#{Project.current.name}&
        caption=A Zooniverse citizen science project&
        description=#{Project.current.description}&
        redirect_uri=#{location.href}
      """.replace '\n', ''

    twitterHref: =>
      text = "I've classified something on #{Project.current.name}!"
      "https://twitter.com/share?text=#{text}&url=#{@talkHref()}&hashtags=#{Project.current.slug}"

  User.bind 'sign-in', Favorite.reload

  module.exports = Favorite
