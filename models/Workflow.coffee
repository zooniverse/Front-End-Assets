define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  API = require 'zooniverse/API'
  {joinLines} = require 'zooniverse/util'

  Subject = require 'zooniverse/models/Subject'

  class Workflow extends Spine.Model
    @configure 'Workflow', 'queueLength', 'selectionLength', 'tutorialSubjects', 'project', 'subjects'

    queueLength: 5 # Number of subjects to preload
    selectionLength: 1 # Number of subjects to be classified at a time

    selection: null

    constructor: ->
      super

      @subjects ?= []
      @subjects = [@subjects] unless @subjects instanceof Array

      @tutorialSubjects ?= []
      @tutorialSubjects = [@tutorialSubjects] unless @tutorialSubjects instanceof Array

      subject.workflow = @ for subject in @subjects.concat @tutorialSubjects

      @selection ?= []

    fetchSubjects: (group) =>
      @trigger 'fetching'
      fetch = new $.Deferred

      groupSegment = ''
      groupSegment = '/#{group}' if typeof group is 'string'

      url = joinLines """
        /projects/#{@project.id}
        #{groupSegment}
        /subjects
        ?limit=#{@queueLength - @subjects.length}
      """

      get = API.get url

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
