define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  class Favorite extends Spine.Model
    @configure 'Favorite', 'subjectIds'

    @project:
      facebookAppId: '310507282327045'
      name: 'Zooniverse'
      slug: 'zooniverse'
      description: 'Real Science Online'

    persist: =>
      @trigger 'persisting'

      post = $.post '//localhost:3000/projects/4fa4088d54558f3d6a000001/favorites',
        favorite:
          subject_ids: @subjectIds

      post.done =>
        @trigger 'persist'

      post.fail =>
        @trigger 'error'

    href: =>
      "#{location.protocol}//#{location.host}/%23!/review/#{@zooniverseId}"

    facebookHref: =>
      encodeURI ("""
        https://www.facebook.com/dialog/feed?
        app_id=#{@constructor.project.facebookAppId}&
        link=#{@href()}&
        picture=#{@location.image || @location}&
        name=#{@constructor.project.name}&
        caption=A Zooniverse citizen science project&
        description=#{@constructor.project.description}&
        redirect_uri=#{location.href}
      """).replace '\n', ''

    twitterHref: =>
      text = "I've classified something at #{@constructor.project.name}!"

      encodeURI "https://twitter.com/share?url=#{@href()}&text=#{text}&hashtags=#{@constructor.project.slug}"

  module.exports = Favorite
