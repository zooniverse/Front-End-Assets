define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  Project = require 'zooniverse/models/Project'
  User = require 'zooniverse/models/User'

  class Favorite extends Spine.Model
    @configure 'Favorite', 'subjects', 'createdAt'

    constructor: ->
      super

      @createdAt ?= new Date

    fromJSON: (raw) ->
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
        @trigger 'fetch'
        console.log response
        # handle.resolve

      request.fail @trigger 'error'

      handle.promise()

    persist: =>
      @trigger 'persisting'

      post = $.post "#{Project.current.host}/projects/#{Project.current.id}/favorites",
        favorite:
          subject_ids: (subject.id for subject in @subjects)

      post.done =>
        @trigger 'persist'
        @fetch()

      post.fail =>
        @trigger 'error'

    href: =>
      "#{location.protocol}//#{location.host}/%23!/review/#{@zooniverseId}"

    facebookHref: =>
      encodeURI ("""
        https://www.facebook.com/dialog/feed?
        app_id=#{Project.current.facebookAppId}&
        link=#{@href()}&
        picture=#{@subjects[0].location || @subjects[0].image || @subjects[0].location.image}&
        name=#{Project.current.name}&
        caption=A Zooniverse citizen science project&
        description=#{Project.current.description}&
        redirect_uri=#{location.href}
      """).replace '\n', ''

    twitterHref: =>
      text = "I've classified something at #{Project.current.name}!"

      encodeURI "https://twitter.com/share?url=#{@href()}&text=#{text}&hashtags=#{Project.current.slug}"

  module.exports = Favorite
