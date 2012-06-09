define (require, exports, module) ->
  Spine = require 'spine'

  class Subject extends Spine.Model
    # Belongs to a workflow
    @configure 'Subject', 'zooniverseID', 'location', 'coords', 'metadata', 'workflow'

    @current: null
    @queueLength: 3

    @fromJSON: (raw) ->
      created = @create
        workflow: raw.workflow_ids[0] # Converted to a workflow at "from-json" trigger
        id: raw.id
        zooniverseID: raw.zooniverse_id
        location: raw.location
        coords: raw.coords
        metadata: raw.metadata

      @trigger 'from-json', created

      created

    constructor: ->
      super
      throw new Error 'Subject created without a workflow' unless @workflow?

    talkHref: =>
      "#{@workflow.project.app.talkHost}/objects/#{@zooniverseID}"

    facebookHref: =>
      """
        https://www.facebook.com/dialog/feed?
        app_id=#{@workflow.project.facebookAppId}&
        link=#{@talkHref()}&
        picture=#{@location.image || @location}&
        name=#{@workflow.project.name}&
        caption=A Zooniverse citizen science project&
        description=#{@workflow.project.description}&
        redirect_uri=#{location.href}
      """.replace /\n/g, ''

    twitterHref: =>
      text = "I've classified something on #{@workflow.project.name}!"
      "https://twitter.com/share?text=#{text}&url=#{@talkHref()}"

  module.exports = Subject
