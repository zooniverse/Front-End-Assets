define (require, exports, module) ->
  Spine = require 'Spine'

  config = require 'zooniverse/config'
  {joinLines} = require 'zooniverse/util'

  class Subject extends Spine.Module
    @include Spine.Events

    @fromJSON: (raw) =>
      new @
        id: raw.id
        zooniverseID: raw.zooniverse_id
        location: raw.location
        coords: raw.coords
        metadata: raw.metadata

    id: ''
    zooniverseID: ''
    location: ''
    coords: ''
    metadata: ''

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

    talkHref: =>
      "#{config.talkHost}/objects/#{@zooniverseID}"

    facebookHref: =>
      joinLines """
        https://www.facebook.com/dialog/feed?
        app_id=#{config.facebookAppId}&
        link=#{@talkHref()}&
        picture=#{@location.image || @location}&
        name=#{config.name}&
        caption=A Zooniverse citizen science project&
        description=#{config.description}&
        redirect_uri=#{location.href}
      """

    twitterHref: =>
      text = "I've classified something on #{config.name}!"
      "https://twitter.com/share?text=#{text}&url=#{@talkHref()}"

  module.exports = Subject
