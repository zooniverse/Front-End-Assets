define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  class Subject extends Spine.Model
    @configure 'Subject'

    @host: 'HOST'
    @project: 'PROJECT_ID'

    @current: null
    @queueLength: 3

    @fromJSON: (raw) ->
      # Override this.
      # Do whatever transforms you need to do
      # on the raw data, then call super on it.
      super raw

    @forTutorial: ->
      # Override this.
      # Return a preset instance (i.e. for a tutorial).
      @create {}

    @fetch: (group) ->
      @trigger 'fetching'

      handle = new $.Deferred

      handle.done (subjects) =>
        @trigger 'fetch', subjects

      handle.fail (args...) =>
        @trigger 'error', args

      queue = (instance for instance in @all() when not instance.eql @current)

      # If there's a big enough queue, resolve with that.
      handle.resolve queue[0...@queueLength] if queue.length >= @queueLength

      # If the queue is running low, get more from the server.
      if queue.length <= @queueLength
        groupSegment = ''
        groupSegment = "#{group}/" if group?

        url = "#{@host}/projects/#{@project}/groups/#{groupSegment}subjects?limit=#{@queueLength - queue.length}"
        request = $.getJSON url

        request.done (response) =>
          handle.resolve (@fromJSON item for item in response)

        request.fail (args...) ->
          handle.reject args...

      handle.promise()

    @setCurrent: (newCurrent) ->
      return if newCurrent is @current
      @current?.destroy()
      @current = newCurrent
      @trigger 'change-current', newCurrent

  module.exports = Subject
