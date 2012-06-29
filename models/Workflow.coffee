define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  {joinLines} = require 'zooniverse/util'

  Subject = require 'zooniverse/models/Subject'

  class Workflow extends Spine.Model
    @configure 'Workflow', 'devID', 'queueLength', 'selectionLength', 'tutorialSubjects', 'project', 'subjects'

    queueLength: 5 # Number of subjects to preload
    selectionLength: 1 # Number of subjects to be classified at a time

    selection: null

    constructor: ->
      super
      @id = @devID if config.dev

      @subjects ?= []
      @tutorialSubjects ?= []
      subject.workflow = @ for subject in @subjects.concat @tutorialSubjects

      @controller?.workflow = @ # The delay in controller constructor waits for this.

    fetchSubjects: (group) =>
      @trigger 'fetching'
      fetch = new $.Deferred

      groupSegment = ''
      groupSegment = '/#{group}' if typeof group is 'string'

      url = joinLines """
        #{config.apiHost}
        /projects/#{@project.id}
        #{groupSegment}
        /subjects
        ?limit=#{@queueLength - @subjects.length}
      """

      get = $.getJSON url

      get.done (response) =>
        for raw in response
          continue unless raw # TODO: Why am I getting some nulls back?

          subject = Subject.fromJSON raw
          subject.workflow = @
          @subjects.push subject

          if subject.location.standard
            # Preload each subject
            img = $("<img src='#{subject.location.standard}' />")
            img.css height: 0, opacity: 0, position: 'absolute', width: 0
            img.appendTo 'body'

        fetch.resolve @subjects
        @trigger 'fetch'

      get.fail (response) =>
        fetch.reject response

      fetch.promise()

    nextSubjects: =>
      fetch = @fetchSubjects()
      next = new $.Deferred

      @trigger 'changing-selection'

      if @subjects.length >= @selectionLength
        @changeSelection()
        next.resolve @selection
      else
        fetch.done =>
          if @subjects.length >= @selectionLength
            @changeSelection()
            next.resolve @selection
          else
            next.reject()

      next.promise()

    changeSelection: =>
      if @subjects.length < @selectionLength
        alert 'We\'ve run out of subjects for you to classify on this project!'

      @selection = @subjects.splice 0, @selectionLength
      @trigger 'change-selection', @selection

  module.exports = Workflow
